class CompanyController < ApplicationController
  before_filter :find_organization, :only => [:show, :calendar, :edit, :update]
  layout :company, :except => [:index]

  private

    def company
      if defined? @organization
        if File.exist?( "app/views/layouts/#{@organization.theme}.html.haml" )
          @organization.theme
        else
          'company'
        end
      else
        'application'
      end
    end

end
