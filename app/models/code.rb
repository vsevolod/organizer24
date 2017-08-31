# == Schema Information
#
# Table name: codes
#
#  id              :integer          not null, primary key
#  number          :string(255)
#  worker_id       :integer
#  cost            :float
#  status          :string(255)
#  user_id         :integer
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Code < ApplicationRecord
  include AASM

  belongs_to :worker
  belongs_to :user
  belongs_to :organization
  # attr_accessible :cost, :number, :status, :worker_id

  validates :cost, presence: true
  validates :number, presence: true, uniqueness: { scope: [:organization_id] }

  aasm column: :status do
    state :created, initial: true # Создан
    state :sended                 # Отдан
    state :completed              # Выполнен
  end
end
