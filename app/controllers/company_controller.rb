class CompanyController < ApplicationController
  include SetLayout
  before_filter :find_organization
  before_filter :check_iframe
  around_filter :company_time_zone
  layout :company

  def prepare_calendar_options
    @start = params[:start].to_time
    @end = params[:end].to_time
  end

  private

    def company_time_zone( &block )
      Time.use_zone( @organization.try(:timezone) || Time.zone ) do
        block.call
      end
    end

    def get_worker
      @organization.workers.enabled.where(:id => params[:worker_id]).first || @organization.workers.first
    end

end
