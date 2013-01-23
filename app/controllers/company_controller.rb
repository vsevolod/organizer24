class CompanyController < ApplicationController
  include SetLayout
  before_filter :find_organization
  around_filter :company_time_zone
  layout :company

  def prepare_calendar_options
    @start = Time.zone.at( params[:start].to_i )
    @end = Time.zone.at( params[:end].to_i )
  end

  private

    def company_time_zone( &block )
      Time.use_zone( @organization.try(:timezone) || Time.zone ) do
        @utc_offset = Time.zone.now.utc_offset + cookies["offset"].to_i*60
        block.call
      end
    end

end
