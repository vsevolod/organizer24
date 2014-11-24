class Service < ActiveRecord::Base

  scope :not_collections, where( "is_collection != 't' OR is_collection IS NULL" )

  belongs_to :category, :class_name => 'Dictionary'
  belongs_to :organization
  has_and_belongs_to_many :appointments

  has_many :collections_services, :foreign_key => :collection_id
  has_many :services, :through => :collections_services
  has_many :services_workers, dependent: :destroy
  has_many :workers, :through => :services_workers

  accepts_nested_attributes_for :collections_services

  validates :name, :presence => true, :uniqueness => { :scope => [:organization_id] }
  validates :showing_time, :presence => true
#  validates :cost, presence: { if: Proc.new{|service| service.bottom_cost.blank? && service.top_cost.blank? }}

  validates :new_date_cost, presence: true, if: Proc.new{|sw| sw.new_cost.present?}
  after_validation :check_new_cost

  def check_new_cost
    update_new_cost! if self.new_cost_changed? || self.new_date_cost_changed?
  end

  def update_new_cost!
    Delayed::Job.where('handler ILIKE ? AND handler ILIKE ?', "%ruby/ActiveRecord:Service%", "%id: '#{self.id}'%").destroy_all
    if self.new_date_cost <= Date.today
      self.cost = new_cost
      self.new_cost = nil
      self.new_date_cost = nil
    else
      self.delay(run_at: self.new_date_cost).update_new_cost!
      first_day = [self.new_date_cost, self.new_date_cost_was].compact.min
      self.appointments.where(:start.gteq => first_day).each{|a| a.cost_time_by_services!(false)}
    end
  end

  def full_info( joins = ' / ' )
    [self.name, self.showing_time.show_time, self.cost].join(joins)
  end

end
