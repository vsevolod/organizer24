class Worker < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many :services_workers
  has_many :services, :through => :services_workers

  accepts_nested_attributes_for :services_workers

  attr_accessible :name, :is_enabled, :services_workers_attributes

end
