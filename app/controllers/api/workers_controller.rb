class Api::WorkersController < ApiController
  def index
    @workers = @organization.workers.enabled
    render json: @workers
  end
end
