class Users::SessionsController < Devise::SessionsController
  include UserService
  include SetLayout

  before_action :find_organization
  layout :company, except: 'new'

  def new
    @resource = resource_class.new
    @resource.phone = prepare_phone(params[:user][:phone]) if (params[:user] || {})[:phone]
    if params[:remote] == 'true'
      render layout: false
    else
      render layout: company
    end
  end

  def create
    params[:user][:phone] = prepare_phone(params[:user][:phone])
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
