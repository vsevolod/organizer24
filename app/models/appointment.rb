class Appointment < ActiveRecord::Base
  include AASM

  belongs_to :user                  # Клиент
  belongs_to :user_by_phone, :class_name => 'User', :foreign_key => :phone, :primary_key => :phone # Клиент по номеру телефона
  belongs_to :organization          # Организация
  has_and_belongs_to_many :services # Услуги

  accepts_nested_attributes_for :services
  before_save :update_complete_time

  #before_validation :count_cost_time

  aasm :column => :status do
    state :free, :initial => true # Свободно
    state :taken        # Занято
    state :inaccessible # Недоступно
    state :offer        # Есть заявка
    state :aproove      # Подтверждена
    state :complete     # Выполнена
    state :missing      # Пропущена. Клиент не пришёл
    state :lated        # Задержана. Клиент опоздал
    state :cancel_client# Отменена клиентом
    state :cancel_owner # Отменена владельцем

    event :first_owner_view do
      transitions :to => :offer, :from => :free
    end
  end

  validates :start, :presence => true
  validates :organization, :showing_time => { :start => :start, :showing_time => :showing_time }

  # FIXME appointment_services - это правильная форма? сравнить при написании view
  attr_accessible :start, :organization_id, :appointment_services, :showing_time

  # Возвращаем стоимость и время в зависимости от колекций.
  def cost_time_by_services!
    cost = 0
    time = 0
    values = self.service_ids.dup
    self.organization.get_services.each do |cs|
      if (cs[0] & values).size == cs[0].size
        cost += cs[1]
        time += cs[2]
        values = values - cs[0]
      end
    end
    self.cost = cost
    self.showing_time = time
  end

  def _end
    self.start + self.showing_time.minutes
  end

  private

    def update_complete_time
      if self.status_changed? && %w{complete missing lated cancel_owner cancel_client}.include?( self.status )
        self.complete_time = Time.now
      end
    end

end
