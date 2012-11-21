class SessionsController < Devise::SessionsController
  include SetLayout
  before_filter :find_organization
  layout :company, :except => 'new'

  def new
    build_resource
    if resource.phone
      render :layout => 'company'
    else
      render :layout => false
    end
    resource.phone = params[:user][:phone] if (params[:user] || {})[:phone]
  end

end
