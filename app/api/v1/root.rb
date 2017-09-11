module API
  module V1
    class Root < Grape::API
      version 'v1'

      include Entities

      route_param :telegram_id do
        helpers do
          def current_user
            @current_user ||= ::TelegramUser.find_by!(telegram_id: params[:telegram_id])
          end
        end

        mount API::V1::Auth
        mount API::V1::Users
      end
    end
  end
end
