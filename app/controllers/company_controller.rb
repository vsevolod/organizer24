class CompanyController < ApplicationController
  include SetLayout
  before_filter :find_organization
  layout :company

  def prepare_calendar_options
    @start = Time.at( params[:start].to_i )
    @end = Time.at( params[:end].to_i )
  end

end
