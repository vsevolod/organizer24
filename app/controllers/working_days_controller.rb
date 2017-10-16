# coding: utf-8
class WorkingDaysController < CompanyController
  before_action :find_worker
  before_action :prepare_calendar_options, only: [:index, :inverse_day]

  respond_to :html, :json

  def index
    @working_days = @worker.working_days.where(date: @start..@end)

    @periods = []
    @working_days.each do |working_day|
      @periods << {
        title: 'Работает',
        allDay: true,
        start: working_day.date,
        editable: true
      }
    end
    respond_with(@periods)
  end

  def inverse_day
    @working_day = @worker.working_days.where(date: @start.to_date).first_or_initialize
    if @working_day.new_record?
      @working_day.save
    else
      @working_day.destroy
    end
    render plain: 'Complete'
  end

  def clear_all
    @worker.working_days.destroy_all
    render plain: "$('#worker_month_calendar').fullCalendar('refetchEvents')"
  end

  private

  def find_worker
    @worker = Worker.find_by(id: params[:worker_id])
  end
end
