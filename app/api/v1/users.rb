require_dependency 'app/controllers/users'

module API
  module V1
    class Users < Grape::API
      resource :users do
        desc 'Connect telegram with existing user'
        params do
          requires :phone, type: String
        end
        post '/connect' do
          phone = PhoneService.parse(params[:phone])
          user = User.find_by!(phone: phone)

          ConnectService.generate!(current_user, user)

          present confirmation_number: current_user.confirmation_number
        end
      end
    end
  end
end
