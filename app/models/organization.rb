class Organization < ApplicationRecord
  ACCESSORS = [
    :slot_minutes,          # Кол-во минут
    :last_day,              # Последний день для записи
    :theme,                 # Тема
    :registration_before,   # Обязательная регистрация до записи
    :show_photogallery,     # Показывать фотогалерею
    :timezone,              # Зона (TODO need to deprecate)
    :user_notify_text,      # Текст смс уведомления
    :index_header           # Заголовок на главной
  ].freeze

  # Deprecated
  THEMES = %w{amelia cerulean cyborg journal readable simplex slate spacelab superhero spruce united}.freeze

  # Пара (Название схемы - категория схемы)
  # TODO move themes to table
  ACTUAL_THEMES = {
    'embark'  => 'embark',
    'beauty'  => 'beauty',
    'sadmin'  => 'sadmin',
    'sadmin2' => 'sadmin'
  }.freeze

  GENITIVE_WEEK_DAYS = %w(воскресенье понедельник вторник среду четверг пятницу субботу).freeze

  store :settings, accessors: ACCESSORS

  belongs_to :activity, class_name: 'Dictionary'
  belongs_to :owner, class_name: 'User'
  has_one  :sms_ru
  has_many :notifications, dependent: :destroy
  has_many :codes, dependent: :destroy
  has_many :appointments
  has_many :services
  has_many :users
  has_many :pages
  has_many :category_photos
  has_many :workers
  has_many :working_hours, through: :workers
  has_many :dictionaries
  has_many :double_rates
  has_many :services_users

  accepts_nested_attributes_for :dictionaries
  accepts_nested_attributes_for :workers
  accepts_nested_attributes_for :services

  validates :timezone, inclusion: { in: ActiveSupport::TimeZone.all.map(&:name) + [nil] }
  validates :name, presence: true
  validates :activity, presence: true
  validates :domain, presence: true, uniqueness: true

  # attr_accessible :name, :activity_id, :domain, :owner_id, :activity, :dictionaries_attributes, :services_attributes, :workers_attributes, *ACCESSORS
  before_validation :check_domain

  def get_theme
    ACTUAL_THEMES.fetch(theme, 'default')
  end

  def get_services(phone, type = :extend)
    s_users = ServicesUser.where(phone: phone, organization_id: id)
    services.map do |s|
      service_ids = if type == :extend && s.is_collection?
                      s.collections_services.pluck(:service_id)
                    else
                      [s.id]
                    end
      if service_user = s_users.find { |su| su.service_id == s.id }
        [service_ids, service_user.cost || s.cost, service_user.showing_time || s.showing_time]
      else
        [service_ids, s.cost, s.showing_time, s.new_cost, s.new_date_cost]
      end
    end.sort_by { |cs| 1000 - cs.first.size }
  end

  def registration_before?
    registration_before.to_i == 1
  end

  def show_photogallery?
    show_photogallery.to_i == 1
  end

  def owner_phones
    workers.pluck(:phone).push(owner.phone)
  end

  def children_category_of(tag)
    if dictionary = dictionaries.where(tag: tag).first
      dictionary.children
    else
      []
    end
  end

  private

  def to_Date(seconds)
    { hours: seconds / 60 / 60, minutes: seconds / 60 % 60 }
  end

  def check_domain
    if domain
      self.domain = Russian.translit(domain) if domain =~ /[а-яА-Я]/
      self.domain = nil if domain =~ /^[^\.]+clickbook/
    end
  end
end
