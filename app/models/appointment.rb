class Appointment < ActiveRecord::Base
  include AASM

  # TODO сделать user по умолчанию через телефон. Убрать связь через user_id
  belongs_to :user                  # Клиент
  belongs_to :user_by_phone, :class_name => 'User', :foreign_key => :phone, :primary_key => :phone # Клиент по номеру телефона
  belongs_to :organization          # Организация
  belongs_to :worker
  has_many :notifications
  has_many :services_users, :foreign_key => :phone, :primary_key => :phone
  has_and_belongs_to_many :services # Услуги

  before_save :update_complete_time
  # TODO
  #before_save :update_cost
  before_validation :check_start_time
  before_validation :cost_time_by_services!
  before_validation :check_services_on_expire
  after_save :notify_owner, :if => :can_notify_owner?
  after_save :change_start_notification, :if => :start_or_status_changed

  attr_accessor :can_not_notify_owner # Не нужно уведомлять владельца

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

    event :complete_appointment do
      transitions :to => :complete
    end

    event :cancel_appointment_by_client do
      transitions :to => :cancel_client
    end
  end

  FINISH_STATES = %w{complete missing lated cancel_owner cancel_client}
  STARTING_STATES = %w{taken your-offer offer approve}

  validates :start, presence: true
  validates :phone, presence: true
  validates :firstname, presence: true, unless: :'free?'
  validates :worker, presence: true
  validates :organization, showing_time: { start: :start, showing_time: :showing_time }
  validates_numericality_of :showing_time, greater_than: 0

  # FIXME appointment_services - это правильная форма? сравнить при написании view
  attr_accessible :start, :organization_id, :appointment_services, :showing_time, :service_ids, :phone, :firstname, :lastname, :services_users_attributes, :worker_id, :comment

  # Возвращаем стоимость и время в зависимости от колекций.
  def cost_time_by_services!(with_showing_time = true)
    # Обновлять только если не была изменена стоимость (для созданной записи)
    # И статус != ожидаемый
    if (self.new_record? || !self.cost_changed?) && !%w{missing cancel_owner cancel_client}.include?( self.status )
      new_cost = 0
      time = 0
      values = self.service_ids.dup
      self.organization.get_services( self.phone ).each do |cs|
        if (cs[0] & values).size == cs[0].size
          new_cost += if cs[3] && cs[4] < self.start.to_date
            cs[3]
          else
            cs[1]
          end.to_i
          time += cs[2]
          values = values - cs[0]
        end
      end
      self.cost = new_cost
      if !self.showing_time_changed? && !self.complete? && with_showing_time
        self.showing_time = time
      end

      # подсчет цены в зависимости от тарифа
      # TODO: исправить подсчет. Сейчас идёт так: находится первое пересечение(двойного тарифа) и умножается на среднее от всех двойных тарифов
      if (drs = get_double_rates).any?
        excluded = [[self.start_seconds, self.end_seconds]].exclude!(drs.map{|wh| [wh.begin_time, wh.end_time]}).first || [0]
        proportion = 1 - (excluded.last - excluded.first)/(self.showing_time*60)
        self.cost = new_cost * (1.0 - proportion + (drs.sum(:rate)/drs.count) * proportion)
      end
    end
  end

  def _end
    self.start + self.showing_time.minutes
  end

  # конец  записи в секундах
  def end_seconds
    start_seconds + self.showing_time * 60
  end

  # начало записи в секундах
  def start_seconds
    self.start - self.start.at_beginning_of_day
  end

  def fullname
    [self.firstname, self.lastname].join(' ')
  end

  # Может ли пользователь редактировать конкретную запись?
  def editable_by?(edit_user)
    edit_user.owner_or_worker?( self.organization )  ||
    self.user_by_phone == edit_user && self.offer?  ||
    self.user.owner?( self.organization )  && self.phone == edit_user.phone
  end

  # Отправить уведомление владельцу если есть изменения
  def notify_owner
    text = ""
    if self.created_at == self.updated_at || self.status_was == 'free' && self.offer? # Если запись только что создана или подтверждена
      text += "Новая запись: #{self.fullname} (#{self.phone}). Время: #{Russian.strftime( self.start, "%d %B в %H:%M" )}\nУслуги: #{self.services.order(:name).pluck(:name).join(', ')}."
    else
      if start_changed?
        text += "Время начала записи #{self.fullname} (#{self.phone}) изменилось. Было: #{Russian.strftime self.start_was, '%d %B %Y %R'} Стало: #{Russian.strftime self.start, '%d %B %Y %R'}"
      end
      if status_changed?
        translate = Proc.new{ |_state| I18n.t "activerecord.attributes.appointment.status.#{_state}" }
        text += "Статус записи #{self.fullname} (#{self.phone}) изменился. Был \"#{translate.call self.status_was}\", стал \"#{translate.call self.status}\""
        if self.status == 'cancel_client'
          text+= ". Время: #{Russian.strftime self.start, '%d %B %R'}"
        end
      end
      if cost_changed? || showing_time_changed?
        text += "Список услуг записи #{self.fullname} (#{self.phone}) изменился: #{services.order(:name).pluck(:name).join(', ')}"
      end
    end
    if !text.blank? && !self.organization.owner_phones.include?(self.phone) # Не уведомляем если на телефон мастера
      # Проверка на наличие мастера онлайн
      phone = self.worker(organization).try(:phone) || organization.owner.phone
      #if $redis.hkeys('phones').include?(phone)
      #  $redis.publish 'socket.io#*', [{type: 2, data: ['message', self.user.name, text]}, {rooms: [phone]}].to_msgpack
      #end
      if self.worker.push_key.present?
        Delayed::Job.enqueue BoxCarJob.new( { message: text, authentication_token: self.worker.push_key } ), :run_at => Time.zone.now
      else
        Delayed::Job.enqueue SmsJob.new( { text: text, phone: phone }, 'simple_notify' ), :run_at => Time.zone.now
      end
    end
  end

  def change_start_notification
    destroy_user_notifications
    if self.starting_state? && !self.organization.owner_phones.include?(self.phone) # Уведомляем только если запись активна и не на наш телефон
      Delayed::Job.enqueue SmsJob.new( {:appointment_id => self.id }, 'notification' ), :run_at => (self.start - 1.day)
    end
  end

  # Берем пользователя либо создаем нового из параметров
  def enshure_user
    if self.user.owner_or_worker?(self.organization)
      User.new( :phone => self.phone, :firstname => self.firstname, :lastname => self.lastname )
    else
      self.user
    end
  end

  def finish_state?
    FINISH_STATES.include?( self.status )
  end

  def starting_state?
    STARTING_STATES.include?( self.status )
  end

  def can_notify_owner?
    !can_not_notify_owner && !self.free?
  end

  # Двойные тарифы записи
  def get_double_rates
    self.worker.double_rates.where(<<-SQL, {week_day: self.start.wday, current_day: self.start.to_date, start: self.start_seconds, end: self.end_seconds})
      (week_day = :week_day OR day = :current_day)
      AND GREATEST(:start, begin_time) < LEAST(:end, end_time)
    SQL
  end

  #def send_to_redis
  #  appointment_hash = {worker_id: worker_id, start: start.iso8601, id: id}
  #  $redis.publish 'socket.io#*', [{type: 2, data: ['refresh event', appointment_hash]}, {}].to_msgpack
  #end

  #TODO удалить когда появится метод
  def human_state
    AASM::Localizer.new.human_state_name(self.class, self.aasm_read_state)
  end

  private

    def check_start_time
      #TODO remove after 26.10.2014 (and change time zone for server)
      #if Rails.env == 'production' && self.start_changed?
      #  if self.start && self.start.to_date >= '26.10.2014'.to_date
      #    self.start = self.start - 1.hour
      #  end
      #end
      if ['taken', 'offer', 'approve'].include? self.status
        self.errors[:start] = "не может быть меньше текущего времени" if start <= Time.zone.now
      end
    end

    # Проверка сервисов на прекращенные
    def check_services_on_expire
      if self.worker && date_off = self.worker.services_workers.can_be_expired.where(:date_off.lteq => self.start, :service_id.in => self.service_ids).pluck(:date_off).min
        self.errors[:start] = "не может быть больше, #{date_off}"
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

    def start_or_status_changed
      (!self.free? && self.start_changed?) || (self.status_was == 'free' && self.offer?)
    end

    def update_cost
      self.worker.double_rates.where("week_day = :wday OR day = :day", {wday: self.start.wday, day: self.start.localtime.to_date}).where('start')
    end

end
