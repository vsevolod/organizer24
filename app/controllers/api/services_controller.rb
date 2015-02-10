class Api::ServicesController < ApiController

  def index
    @services = @organization.services
    render json: @services
  end

end
