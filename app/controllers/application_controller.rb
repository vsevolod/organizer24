class ApplicationController < ActionController::Base
  protect_from_forgery

  private

    def find_organization
      @organization = Organization.find( params[:organization_id] )
    end
end
