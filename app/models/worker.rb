# == Schema Information
#
# Table name: workers
#
#  id                 :integer          not null, primary key
#  organization_id    :integer
#  name               :string(255)
#  is_enabled         :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  phone              :string(255)
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#  profession         :string(255)
#  dative_case        :string(255)
#  push_key           :string(255)
#  finished_date      :date
#  sms_translit       :boolean
#

class Worker < ApplicationRecord
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

  SETTINGS_KEYS = %w[
    profession
    dative_case
    push_key
    sms_translit
    telegram_enabled
  ]
  store :settings, accessors: SETTINGS_KEYS

  # attr_accessible :name, :is_enabled, :services_workers_attributes, :phone, :user_id, :photo, :service_ids, :working_hours_attributes, :profession, :dative_case, :double_rates_attributes, :push_key, :finished_date, :sms_translit

  has_attached_file :photo, styles: { normal: '230x320>', thumb: '100x100>', sadmin_left: '100x100#' },
                            convert_options: { thumb: '-quality 75 -strip' }
  validates_attachment_content_type :photo, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  scope :enabled, ->{ where(is_enabled: true) }
end
