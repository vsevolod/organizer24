class Notification < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :worker
  belongs_to :organization
  belongs_to :appointment
  # attr_accessible :cost, :status, :notification_type

  aasm column: :status do
    state :start, initial: true
    state :send
    state :complete
    state :cancel

    event :sended do
      transitions to: :send, from: :start
    end

    event :completed do
      transitions to: :complete, from: :send
    end

    event :canceled do
      transitions to: :cancel, from: :send
    end
  end
end
