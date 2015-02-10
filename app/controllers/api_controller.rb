class ApiController < CompanyController
  layout false

  def render_json_error object
    render json: {old: object.reload, errors: object.errors.to_hash }, status: :bad_request
  end

end
