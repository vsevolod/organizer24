# == Schema Information
#
# Table name: appointments
#
#  id              :integer          not null, primary key
#  start           :datetime
#  showing_time    :integer
#  status          :string(255)
#  user_id         :integer
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  cost            :integer
#  phone           :string(255)
#  complete_time   :datetime
#  firstname       :string(255)
#  lastname        :string(255)
#  worker_id       :integer
#  comment         :string(255)
#

class Appointment < ApplicationRecord
  include AASM

  # TODO: сделать user по умолчанию через телефон. Убрать связь через user_id
  belongs_to :user # Клиент
  belongs_to :user_by_phone, class_name: 'User', foreign_key: :phone, primary_key: :phone # Клиент по номеру телефона
  belongs_to :organization          # Организация
  belongs_to :worker
  has_many :notifications
  has_many :services_users, foreign_key: :phone, primary_key: :phone
  has_and_belongs_to_many :services # Услуги

  validates :start, presence: true
  validates :phone, presence: true
  validates :firstname, presence: true, unless: :'free?'
  validates :worker, presence: true
  validates :organization, showing_time: { start: :start, showing_time: :showing_time }
  validates :showing_time, numericality: { greater_than: 0 }

  before_validation :check_start_time
  before_validation :cost_time_by_services!
  before_validation :check_services_on_expire

  before_save :update_complete_time
  after_save :notify_owner, if: :can_notify_owner?
  after_save :change_start_notification, if: :start_or_status_changed

  attr_accessor :can_not_notify_owner # Не нужно уведомлять владельца

  accepts_nested_attributes_for :services
  accepts_nested_attributes_for :services_users

  aasm column: :status do
    state :free, initial: true # Свободно
    state :taken        # Занято
    state :inaccessible # Недоступно
    state :offer        # Есть заявка
    state :approve      # Подтверждена
    state :complete     # Выполнена
    state :missing      # Пропущена. Клиент не пришёл
    state :lated        # Задержана. Клиент опоздал
    state :cancel_client # Отменена клиентом
    state :cancel_owner # Отменена владельцем

    event :first_owner_view do
      transitions from: [:offer, :free], to: :offer
    end

    event :complete_appointment do
      transitions to: :complete
    end

    event :cancel_appointment_by_client do
      transitions to: :cancel_client
    end
  end

  FINISH_STATES = %w(complete missing lated cancel_owner cancel_client).freeze
  STARTING_STATES = %w(taken your-offer offer approve).freeze

  # FIXME: appointment_services - это правильная форма? сравнить при написании view
  # attr_accessible :start, :organization_id, :appointment_services, :showing_time, :service_ids, :phone, :firstname, :lastname, :services_users_attributes, :worker_id, :comment

  # Возвращаем стоимость и время в зависимости от колекций.
  def cost_time_by_services!(with_showing_time = true)
    # Обновлять только если не была изменена стоимость (для созданной записи)
    # И статус != ожидаемый
    if (new_record? || !cost_changed?) && !%w(missing cancel_owner cancel_client).include?(status)
      new_cost = 0
      time = 0
      values = service_ids.dup
      organization.get_services(phone).each do |cs|
        next unless (cs[0] & values).size == cs[0].size
        new_cost += if cs[3] && cs[4] < start.to_date
                      cs[3]
                    else
                      cs[1]
        end.to_i
        time += cs[2]
        values -= cs[0]
      end
      self.cost = new_cost
      if !showing_time_changed? && !complete? && with_showing_time
        self.showing_time = time
      end

      # подсчет цены в зависимости от тарифа
      # TODO: исправить подсчет. Сейчас идёт так: находится первое пересечение(двойного тарифа) и умножается на среднее от всех двойных тарифов
      if (drs = get_double_rates).any?
        excluded = [[start_seconds, end_seconds]].exclude!(drs.map { |wh| [wh.begin_time, wh.end_time] }).first || [0]
        proportion = 1 - (excluded.last - excluded.first) / (showing_time * 60)
        self.cost = new_cost * (1.0 - proportion + (drs.sum(:rate) / drs.count) * proportion)
      end
    end
  end

  def _end
    start + showing_time.minutes
  end

  # конец  записи в секундах
  def end_seconds
    start_seconds + showing_time * 60
  end

  # начало записи в секундах
  def start_seconds
    start - start.at_beginning_of_day
  end

  def fullname
    [firstname, lastname].join(' ')
  end

  # Может ли пользователь редактировать конкретную запись?
  def editable_by?(edit_user)
    edit_user.owner_or_worker?(organization) ||
      user_by_phone == edit_user && offer? ||
      user.owner?(organization) && phone == edit_user.phone
  end

  # Отправить уведомление владельцу если есть изменения
  def notify_owner
    text = ''
    if created_at == updated_at || status_was == 'free' && offer? # Если запись только что создана или подтверждена
      text += "Новая запись: #{fullname} (#{phone}). Время: #{Russian.strftime(start, '%d %B в %H:%M')}\nУслуги: #{services.order(:name).pluck(:name).join(', ')}."
    else
      if start_changed?
        text += "Время начала записи #{fullname} (#{phone}) изменилось. Было: #{Russian.strftime start_was, '%d %B %Y %R'} Стало: #{Russian.strftime start, '%d %B %Y %R'}"
      end
      if status_changed?
        translate = proc { |_state| I18n.t "activerecord.attributes.appointment.status.#{_state}" }
        text += "Статус записи #{fullname} (#{phone}) изменился. Был \"#{translate.call status_was}\", стал \"#{translate.call status}\""
        if status == 'cancel_client'
          text += ". Время: #{Russian.strftime start, '%d %B %R'}"
        end
      end
      if cost_changed? || showing_time_changed?
        text += "Список услуг записи #{fullname} (#{phone}) изменился: #{services.order(:name).pluck(:name).join(', ')}"
      end
    end
    if !text.blank? && !organization.owner_phones.include?(phone) # Не уведомляем если на телефон мастера
      # Проверка на наличие мастера онлайн
      phone = worker&.phone || organization.owner.phone
      # if $redis.hkeys('phones').include?(phone)
      #  $redis.publish 'socket.io#*', [{type: 2, data: ['message', self.user.name, text]}, {rooms: [phone]}].to_msgpack
      # end
      case
      when worker.user.telegram_user
        TelegramJob.perform_later(message: message.text, telegram_user_id: worker.user.telegram_user.telegram_id)
        # TODO Sent message to telegram
      when worker.push_key.present?
        BoxCarJob.perform_later({ message: text, authentication_token: worker.push_key} )
      else
        SmsJob.perform_later({ text: text, phone: phone }, 'simple_notify')
      end
    end
  end

  def change_start_notification
    destroy_user_notifications
    if starting_state? && !organization.owner_phones.include?(phone) # Уведомляем только если запись активна и не на наш телефон
      SmsJob.set(wait_until: start - 1.day).perform_later({ appointment_id: id }, 'notification')
    end
  end

  # Берем пользователя либо создаем нового из параметров
  def enshure_user
    if user.owner_or_worker?(organization)
      User.new(phone: phone, firstname: firstname, lastname: lastname)
    else
      user
    end
  end

  def finish_state?
    FINISH_STATES.include?(status)
  end

  def starting_state?
    STARTING_STATES.include?(status)
  end

  def can_notify_owner?
    !can_not_notify_owner && !free?
  end

  # Двойные тарифы записи
  def get_double_rates
    worker.double_rates.where(<<-SQL, week_day: start.wday, current_day: start.to_date, start: start_seconds, end: end_seconds)
      (week_day = :week_day OR day = :current_day)
      AND GREATEST(:start, begin_time) < LEAST(:end, end_time)
    SQL
  end

  # def send_to_redis
  #  appointment_hash = {worker_id: worker_id, start: start.iso8601, id: id}
  #  $redis.publish 'socket.io#*', [{type: 2, data: ['refresh event', appointment_hash]}, {}].to_msgpack
  # end

  private

  def check_start_time
    if %w(taken offer approve).include? status
      errors.add(:start, 'не может быть меньше текущего времени') if start <= Time.zone.now
    end
  end

  # Проверка сервисов на прекращенные
  def check_services_on_expire
    if worker && date_off = worker.services_workers.can_be_expired.where(date_off: Time.at(0)..start, service_id: service_ids).pluck(:date_off).min
      errors.add(:start, "не может быть больше, #{date_off}")
    end
  end

  def update_complete_time
    if status_changed? && finish_state?
      destroy_user_notifications
      self.complete_time = Time.zone.now
    end
  end

  def destroy_user_notifications
    Sidekiq::ScheduledSet.new.each do |job|
      if job.display_class == 'SmsJob' && job.display_args.to_s.match(/appointment_id[^\d]+#{id}.+notification/)
        job.delete
      end
    end
  end

  def start_or_status_changed
    (!free? && start_changed?) || (status_was == 'free' && offer?)
  end

  def update_cost
    worker.double_rates.where('week_day = :wday OR day = :day', wday: start.wday, day: start.localtime.to_date).where('start')
  end
end
