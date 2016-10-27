class Api::ServicesUsersController < ApiController
  def index
    @services_users = @organization.services_users.where(phone: params[:phone])
    render json: @services_users
  end
end
