class Users::SessionsController < Devise::SessionsController
  include SetLayout

  before_action :find_organization
  layout :company, except: 'new'

  def new
    self.resource = resource_class.new(sign_in_params)

    resource.phone = PhoneService.parse(params.dig(:user, :phone))
    @remote = params[:remote] == 'true'

    clean_up_passwords(resource)
    yield resource if block_given?

    render layout: !@remote && company
  end

  def create
    params[:user][:phone] = PhoneService.parse(params.dig(:user, :phone))
    super
  end

  private

  def after_sign_in_path_for(resource)
    if current_user.is_admin? && !Subdomain.matches?(request)
      '/organizations/new'
    else
      request.env['omniauth.origin'] || stored_location_for(resource) || root_path
    end
  end
end
