class Code < ActiveRecord::Base
  include AASM

  belongs_to :worker
  belongs_to :user
  belongs_to :organization
  attr_accessible :cost, :number, :status, :worker_id

  validates :cost, presence: true
  validates :number, presence: true, :uniqueness => { :scope => [:organization_id] }

  aasm :column => :status do
    state :created, initial: true # Создан
    state :sended                 # Отдан
    state :completed              # Выполнен
  end

end
