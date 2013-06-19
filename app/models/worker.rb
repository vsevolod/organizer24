class Worker < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :services_workers
  has_many :services, :through => :services_workers
  has_many :working_days
  has_many :appointments

  accepts_nested_attributes_for :services_workers
  accepts_nested_attributes_for :working_days

  validates :name, :presence => true
  validates :phone, :presence => true

  attr_accessible :name, :is_enabled, :services_workers_attributes, :phone

  scope :enabled, where(:is_enabled => true)

end
