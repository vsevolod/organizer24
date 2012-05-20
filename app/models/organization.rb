class Organization < ActiveRecord::Base
  ACCESSORS = [:slot_minutes]

  store :settings, accessors: ACCESSORS

  belongs_to :activity, :class_name => "Dictionary"
  belongs_to :owner, :class_name => "User"
  has_many :executors
  has_many :appointments
  has_many :services
  has_many :users
  has_many :working_hours

  accepts_nested_attributes_for :working_hours, :reject_if => :all_blank
  validates_associated :working_hours, :if => lambda{ |u| u.working_hours.any? }

  validates :name, :presence => true
  validates :activity, :presence => true

  attr_accessible :name, :activity_id, :subdomain, :owner_id, :activity, :working_hours_attributes, *ACCESSORS

  def calendar_settings
    {:slotMinutes => self.slot_minutes.to_i}
  end

end
