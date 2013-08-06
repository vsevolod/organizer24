#coding: utf-8
class Organization < ActiveRecord::Base
  ACCESSORS = [:slot_minutes, :last_day, :theme, :registration_before, :show_photogallery, :timezone, :user_notify_text, :index_header]

  # Deprecated
  THEMES = %w{amelia cerulean cyborg journal readable simplex slate spacelab superhero spruce united}

  GENITIVE_WEEK_DAYS = ['воскресенье', 'понедельник', 'вторник', 'среду', 'четверг', 'пятницу', 'субботу']

  store :settings, accessors: ACCESSORS

  belongs_to :activity, :class_name => "Dictionary"
  belongs_to :owner, :class_name => "User"
  has_many :executors
  has_many :appointments
  has_many :services
  has_many :users
  has_many :pages
  has_many :category_photos
  has_many :workers
  has_many :working_hours, :through => :workers
  has_many :dictionaries


  validates_inclusion_of :timezone, :in => ActiveSupport::TimeZone.zones_map(&:name).keys + [nil]
  validates :name, :presence => true
  validates :activity, :presence => true
  validates :domain, :presence => true, :uniqueness => true

  attr_accessible :name, :activity_id, :domain, :owner_id, :activity, *ACCESSORS
  before_validation :check_domain

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

  def show_photogallery?
    self.show_photogallery.to_i == 1
  end

  def owner_phones
    self.workers.pluck(:phone).push(self.owner.phone)
  end

  private

    def to_Date( seconds )
      {:hours => seconds/60/60, :minutes => seconds/60%60}
    end

    def check_domain
      if self.domain
        if self.domain =~ /[а-яА-Я]/
          self.domain = Russian::translit(self.domain)
        end
        if self.domain =~ /^[^\.]+clickbook/
          self.domain = nil
        end
      end
    end

end
