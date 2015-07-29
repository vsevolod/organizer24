class SessionsController < Devise::SessionsController
  include SetLayout
  before_filter :find_organization
  layout :company, :except => 'new'

  def new
    @resource = resource_class.new
    @resource.phone = params[:user][:phone] if (params[:user] || {})[:phone]
    if params[:remote] == 'true'
      render :layout => false
    else
      render :layout => company
    end
  end

  def create
    prepare_phone
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

    def prepare_phone
      params[:user][:phone] = '+7'+params[:user][:phone].sub(/^8/, '').sub(/^\+7/, '')
    end

end
