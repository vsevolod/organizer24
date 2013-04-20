# coding: utf-8
class WorkingDaysController < CompanyController
  before_filter :prepare_calendar_options, :only => [:index, :inverse_day]

  respond_to :html, :json

  def index
    @worker = Worker.find_by_id(params[:worker_id])
    @working_days = @worker.working_days.where(:date.gteq => @start, :date.lteq => @end)

    @periods = []
    @working_days.each do |working_day|
      @periods << {
        :title => "Работает",
        :allDay => true,
        :start => working_day.date,
        :editable => true
      }
    end
    respond_with( @periods )
  end

  def inverse_day
    @worker = Worker.find_by_id(params[:worker_id])
    @working_day = @worker.working_days.where(:date => @start.to_date).first_or_initialize
    if @working_day.new_record?
      @working_day.save
    else
      @working_day.destroy
    end
    render :text => 'Complete'
  end

end
