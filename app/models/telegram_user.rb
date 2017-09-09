class TelegramUser < ApplicationRecord
  validates :telegram_id, presence: true, uniqueness: true

  scope :confirmed, -> { where(confirmed: true) }
end
