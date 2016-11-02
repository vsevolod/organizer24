class Service < ApplicationRecord
  scope :not_collections, -> { where("is_collection != 't' OR is_collection IS NULL") }

  belongs_to :category, class_name: 'Dictionary'
  belongs_to :organization
  has_and_belongs_to_many :appointments

  has_many :collections_services, foreign_key: :collection_id
  has_many :services, through: :collections_services
  has_many :services_workers, dependent: :destroy
  has_many :workers, through: :services_workers

  accepts_nested_attributes_for :collections_services

  validates :name, presence: true, uniqueness: { scope: [:organization_id] }
  validates :showing_time, presence: true
  #  validates :cost, presence: { if: Proc.new{|service| service.bottom_cost.blank? && service.top_cost.blank? }}

  validates :new_date_cost, presence: true, if: proc { |sw| sw.new_cost.present? }
  after_save :check_new_cost

  def check_new_cost
    update_new_cost! if new_cost_changed? || new_date_cost_changed?
  end

  def update_new_cost!
    Sidekiq::ScheduledSet.new.each do |job|
      if job.display_class.match('update_new_cost!') && job.value.match(/id: '181'/)
        job.delete
      end
    end
    return self unless new_date_cost
    if new_date_cost <= Date.today
      self.cost = new_cost
      self.new_cost = nil
      self.new_date_cost = nil
      save
    else
      delay_until(new_date_cost).update_new_cost!
      first_day = [new_date_cost, new_date_cost_was].compact.min
      if is_collection?
        organization.appointments.where('? = (SELECT count(*) FROM appointments_services WHERE appointments_services.appointment_id = appointments.id AND appointments_services.service_id IN (?))', service_ids.count, service_ids)
      else
        appointments
      end.where(start: first_day..(first_day + 1.year)).find_each { |a| a.cost_time_by_services!(false); a.update_column(:cost, a.cost) }
    end
  end

  def full_info(joins = ' / ')
    [name, showing_time.show_time, cost].join(joins)
  end
end
