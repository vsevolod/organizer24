# == Schema Information
#
# Table name: notifications
#
#  id                :integer          not null, primary key
#  user_id           :integer
#  worker_id         :integer
#  organization_id   :integer
#  cost              :float
#  length            :integer
#  status            :string(255)
#  notification_type :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  appointment_id    :integer
#

class Notification < ApplicationRecord
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
