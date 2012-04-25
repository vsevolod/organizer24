class Appointment < ActiveRecord::Base
  belongs_to :user                  # Клиент
  belongs_to :organization          # Организация
  has_and_belongs_to_many :services # Услуги

  accepts_nested_attributes_for :services

  aasm :column => :status do
    state :free, :initial => true # Свободно
    state :taken        # Занято
    state :inaccessible # Недоступно
    state :offer        # Есть заявка
    state :aproove      # Подтверждено
    state :complete     # Выполнено
    state :missing      # Пропущено. Клиент не пришёл
  end

  validates :start, :presence => true
  validates :organization_id, :showing_time => { :start => :start, :showing_time => :showing_time }

  # FIXME appointment_services - это правильная форма? сравнить при написании view
  attr_accessible :start, :organization_id, :appointment_services

end
