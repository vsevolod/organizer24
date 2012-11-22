class SessionsController < Devise::SessionsController
  include SetLayout
  before_filter :find_organization
  layout :company, :except => 'new'

  def new
    build_resource
    resource.phone = params[:user][:phone] if (params[:user] || {})[:phone]
    if params[:remote] == 'true'
      render :layout => false
    else
      render :layout => company
    end
  end

end
