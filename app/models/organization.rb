class Organization < ActiveRecord::Base

  belongs_to :activity, :class_name => "Dictionary"
  belongs_to :owner, :class_name => "User"
  has_many :executors
  has_many :appointments
  has_many :services
  has_many :users
  has_many :working_hours

  validates :name, :presence => true
  validates :activity, :presence => true

  attr_accessible :name, :activity_id, :subdomain, :owner_id


end
