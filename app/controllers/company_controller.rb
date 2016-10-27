class CompanyController < ApplicationController
  include SetLayout
  before_action :find_organization
  before_action :check_iframe
  around_action :company_time_zone
  layout :company

  def prepare_calendar_options
    @start = Time.parse(params[:start]) if params[:start]
    @end = Time.parse(params[:end]) if params[:end]
  end

  private

  def company_time_zone
    Time.use_zone(@organization.try(:timezone) || Time.zone) do
      yield
    end
  end

  def get_worker
    @organization.workers.enabled.where(id: params[:worker_id]).first || @organization.workers.first
  end

  def find_worker
    @worker = Worker.find(params[:worker_id])
  end
end
