class Organization < ActiveRecord::Base
  ACCESSORS = [:slot_minutes, :last_day, :theme, :registration_before, :show_photogallery, :timezone]
  THEMES = %w{amelia cerulean cyborg journal readable simplex slate spacelab superhero spruce united}

  store :settings, accessors: ACCESSORS

  belongs_to :activity, :class_name => "Dictionary"
  belongs_to :owner, :class_name => "User"
  has_many :executors
  has_many :appointments
  has_many :services
  has_many :users
  has_many :working_hours
  has_many :pages
  has_many :category_photos

  accepts_nested_attributes_for :working_hours, :reject_if => :all_blank
  validates_associated :working_hours, :if => lambda{ |u| u.working_hours.any? }

  validates_inclusion_of :timezone, :in => ActiveSupport::TimeZone.zones_map(&:name)
  validates :name, :presence => true
  validates :activity, :presence => true
  validates :subdomain, :presence => true, :uniqueness => true

  attr_accessible :name, :activity_id, :subdomain, :owner_id, :activity, :working_hours_attributes, *ACCESSORS

  def calendar_settings
    minTime  = self.working_hours.pluck(:begin_time).min
    maxTime  = self.working_hours.pluck(:end_time).max
    sminutes = (self.slot_minutes || 30).to_i
    {:slotMinutes => sminutes, :minTime => minTime, :maxTime => maxTime, :organization_id => self.id}
  end

  def get_services( phone, type = :extend )
    services_users = ServicesUser.where( :phone => phone, :organization_id => self.id )
    self.services.map do |s|
      service_ids = if type == :extend && s.is_collection?
                      s.collections_services.pluck(:service_id)
                    else
                      [s.id]
                    end
      if service_user = services_users.find{|su| su.service_id == s.id}
        [service_ids, service_user.cost || s.cost, service_user.showing_time || s.showing_time]
      else
        [service_ids, s.cost, s.showing_time]
      end
    end.sort_by{|cs| 1000-cs.first.size}
  end

  def registration_before?
    self.registration_before.to_i == 1
  end

  private

    def to_Date( seconds )
      {:hours => seconds/60/60, :minutes => seconds/60%60}
    end

end
