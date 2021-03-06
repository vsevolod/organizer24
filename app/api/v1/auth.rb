module API
  module V1
    class Auth < Grape::API
      desc 'Sign in'
      params do
        optional :username, type: String
      end
      post '/sign_in' do
        user = ::TelegramUser.find_or_initialize_by(telegram_id: params[:telegram_id])
        user.username = params[:username] || 'empty'
        user.save!

        present user, with: Entities::TelegramUser
      end
    end
  end
end
