module API
  module V1
    class TelegramUsers < Grape::API
      resources :telegram_users do
        # POST /api/v1/telegram_users
        desc 'Register a new telegram user'
        params do
          requires :telegram_id, type: Integer
          requires :username, type: String
        end
        post do
          user = TelegramUser.create!(declared(params).to_h)
          present user, with: Entities::TelegramUser
        end

        route_param :telegram_id do
          helpers do
            def user
              TelegramUser.find_by(telegram_id: params[:telegram_id])
            end
          end

          # GET /api/v1/telegram_users/:telegram_id
          desc 'Show telegram user information'
          get do
            present user, with: Entities::TelegramUser
          end
        end
      end
    end
  end
end
