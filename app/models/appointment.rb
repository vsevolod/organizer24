# coding: utf-8
class Appointment < ActiveRecord::Base
  include AASM

  belongs_to :user                  # Клиент
  belongs_to :user_by_phone, :class_name => 'User', :foreign_key => :phone, :primary_key => :phone # Клиент по номеру телефона
  belongs_to :organization          # Организация
  has_many :services_users, :foreign_key => :phone, :primary_key => :phone
  has_and_belongs_to_many :services # Услуги

  before_save :update_complete_time
  before_validation :check_start_time
  before_validation :cost_time_by_services!
  after_save :notify_owner, :if => :can_notify_owner?
  after_save :change_start_notification, :if => :start_changed?

  attr_accessor :can_not_notify_owner

  accepts_nested_attributes_for :services
  accepts_nested_attributes_for :services_users

  aasm :column => :status do
    state :free, :initial => true # Свободно
    state :taken        # Занято
    state :inaccessible # Недоступно
    state :offer        # Есть заявка
    state :approve      # Подтверждена
    state :complete     # Выполнена
    state :missing      # Пропущена. Клиент не пришёл
    state :lated        # Задержана. Клиент опоздал
    state :cancel_client# Отменена клиентом
    state :cancel_owner # Отменена владельцем

    event :first_owner_view do
      transitions :to => :offer, :from => :free
    end
  end
  FINISH_STATES = %w{complete missing lated cancel_owner cancel_client}

  validates :start, :presence => true
  validates :phone, :presence => true
  validates :firstname, :presence => true
  validates :organization, :showing_time => { :start => :start, :showing_time => :showing_time }

  # FIXME appointment_services - это правильная форма? сравнить при написании view
  attr_accessible :start, :organization_id, :appointment_services, :showing_time, :service_ids, :phone, :firstname, :lastname, :services_users_attributes

  # Возвращаем стоимость и время в зависимости от колекций.
  def cost_time_by_services!
    # Обновлять только если не изменено время записи
    # И статус != ожидаемый
    if !self.showing_time_changed? && !%w{complete missing lated cancel_owner cancel_client}.include?( self.status )
      cost = 0
      time = 0
      values = self.service_ids.dup
      self.organization.get_services( self.phone ).each do |cs|
        if (cs[0] & values).size == cs[0].size
          cost += cs[1]
          time += cs[2]
          values = values - cs[0]
        end
      end
      self.cost = cost
      self.showing_time = time
    end
  end

  def _end
    self.start + self.showing_time.minutes
  end

  def fullname
    [self.firstname, self.lastname].join(' ')
  end

  # Может ли пользователь редактировать конкретную запись?
  def editable_by?(edit_user)
    edit_user.owner?( self.organization ) ||
    self.user == edit_user && self.offer? ||
    self.user.owner?( self.organization ) && self.phone == edit_user.phone
  end

  # Отправить уведомление владельцу если есть изменения
  def notify_owner
    text = ""
    if self.created_at == self.updated_at
      text += "Новая запись: #{self.fullname} (#{self.phone}). Время: #{Russian.strftime( self.start, "%d %B в %H:%M" )}\nУслуги: #{self.services.order(:name).pluck(:name).join(', ')}."
    else
      if start_changed?
        text += "Время начала записи ##{self.id} изменилось. Было: #{Russian.strftime self.start_was, '%d %B %Y %R'} Стало: #{Russian.strftime self.start, '%d %B %Y %R'}"
      end
      if status_changed?
        translate = Proc.new{ |_state| I18n.t "activerecord.attributes.appointment.status.#{_state}" }
        text += "Статус записи ##{self.id} изменился. Был \"#{translate.call self.status_was}\", стал \"#{translate.call self.status}\""
      end
      if cost_changed? || showing_time_changed?
        text += "Список услуг записи ##{self.id} изменился: #{services.order(:name).pluck(:name).join(', ')}"
      end
    end
    if !text.blank? || self.phone != self.organization.owner.phone # Не уведомляем если на наш телефон
      Delayed::Job.enqueue SmsJob.new( { :text => text, :phone => organization.owner.phone }, 'notify_owner' ), :run_at => Time.zone.now
    end
  end

  def change_start_notification
    destroy_user_notifications
    Delayed::Job.enqueue SmsJob.new( {:appointment_id => self.id }, 'notification' ), :run_at => (self.start - 1.day)
  end

  # Берем пользователя либо создаем нового из параметров
  def enshure_user
    if self.user.owner? self.organization
      User.new( :phone => self.phone, :firstname => self.firstname, :lastname => self.lastname )
    else
      self.user
    end
  end

  def services_by_user
    services_users = self.organization.get_services( self.phone, :normal ).find_all{|arr| ( arr.first & self.service_ids ).any? }
    services_users.map do |ids, cost, showing_time|
      service = Service.find( ids.first )
      service.cost = cost
      service.showing_time = showing_time
      service
    end
  end

  def finish_state?
    FINISH_STATES.include?( self.status )
  end

  private

    def check_start_time
      if ['taken', 'offer', 'approve'].include? self.status
        record.errors[:start] = "не может быть меньше текущего времени" if start <= Time.zone.now
      end
    end

    def update_complete_time
      if self.status_changed? && finish_state?
        destroy_user_notifications
        self.complete_time = Time.zone.now
      end
    end

    def destroy_user_notifications
      if (notifications_delayed = Delayed::Job.where( "handler ILIKE ?", "%appointment_id: #{self.id}%notification%" )).count > 0
        notifications_delayed.destroy_all
      end
    end

    def can_notify_owner?
      !can_not_notify_owner
    end

end
