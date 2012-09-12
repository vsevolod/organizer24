class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def find_organization
      @organization = Organization.find( params[:organization_id] )
    end

    def redirect_if_not_owner
      if !current_user || !current_user.owner?( @organization )
        redirect_to @organization
      end
    end
end
