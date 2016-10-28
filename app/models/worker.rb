class Worker < ActiveRecord::Base
  belongs_to :user, primary_key: 'phone', foreign_key: 'phone'
  belongs_to :organization
  has_many :services_workers
  has_many :comments, -> { where(author_id: 1) }
  has_many :services, -> { where('date_off IS NULL OR date_off > date(?)', Time.now) }, through: :services_workers
  has_many :working_days, dependent: :destroy
  has_many :working_hours
  has_many :double_rates
  has_many :appointments
  has_many :notifications

  accepts_nested_attributes_for :services_workers, allow_destroy: true
  accepts_nested_attributes_for :working_days, allow_destroy: true
  accepts_nested_attributes_for :working_hours, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :double_rates, reject_if: :all_blank, allow_destroy: true

  validates :name,  presence: true
  validates :phone, presence: true
  validates_associated :working_hours, if: ->(u) { u.working_hours.any? }

  # attr_accessible :name, :is_enabled, :services_workers_attributes, :phone, :user_id, :photo, :service_ids, :working_hours_attributes, :profession, :dative_case, :double_rates_attributes, :push_key, :finished_date, :sms_translit

  has_attached_file :photo, styles: { normal: '230x320>', thumb: '100x100>', sadmin_left: '100x100#' },
                            convert_options: { thumb: '-quality 75 -strip' }

  scope :enabled, ->{ where(is_enabled: true) }
end
