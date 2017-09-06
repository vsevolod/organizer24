module API
  module V1
    module Entities
      class TelegramUser < Entity
        expose :telegram_id
        expose :username
      end
    end
  end
end
