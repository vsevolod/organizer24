# coding: utf-8
class WorkingHoursController < CompanyController
  before_filter :prepare_calendar_options
  before_filter :need_to_login, :only => :self_by_month #TODO может заменить на более популярный метод?
  before_filter :find_worker

  respond_to :html, :json

  # TODO move to appointment controller
  def self_by_month
    @periods = []
    @start_of_month = @start.at_beginning_of_month.to_date
    @start = Date.today if @start < Date.today

    @total_appointments = if current_user.owner? @organization
                            @organization.appointments
                          elsif current_user.worker? @organization
                            current_user.worker.appointments
                          end
    @appointments = (@total_appointments || current_user.appointments.where(:organization_id => @organization.id).where( :status.in => %w{approve offer taken} )).where(:start.gteq => @start, :start.lteq => @end)
    @appointments.each do |appointment|
      data_inner_class = if appointment.offer?
                           'legend-your-offer'
                         else
                           'legend-inaccessible'
                         end
      @periods << { :title => appointment.aasm_human_state, :start => appointment.start.to_i, :end => (appointment.start + appointment.showing_time.minutes).to_i, :editable => false, 'data-inner-class' => data_inner_class, 'data-id' => appointment.id }
    end
    if @total_appointments
      (@end.to_date-@start_of_month).to_i.times do |day|
        if @start_of_month+day == (@start_of_month+day).at_end_of_month && @start_of_month+day < Date.today
          cost = @total_appointments.where(:start.gteq => (@start_of_month+day).at_beginning_of_month, :start.lteq => @start_of_month+(1+day).day).where( :status => ['complete', 'lated'] ).sum(:cost)
          @periods << {:title => "Итог за месяц:#{cost}", :allDay => true, :start => @start_of_month+day.day}
        end
        next if @start_of_month+day > Date.today
        cost = @total_appointments.where(:start.gteq => @start_of_month+day.day, :start.lteq => @start_of_month+(1+day).day).where( :status => ['complete', 'lated'] ).sum(:cost)
        next if cost.zero?
        @periods << {:title => "Итог:#{cost}", :allDay => true, :start => @start_of_month+day.day}
      end
    end
    respond_with( @periods )
  end

  def by_week
    min_wt = @worker.working_hours.pluck(:begin_time).min
    max_wt = @worker.working_hours.pluck(:end_time).max
    @worker = get_worker
    @periods = []
    ((@start.to_date)..(@end.to_date)).each_with_index do |t, index|
      current_day = @start + index.days
      full_day = {:start => (current_day+min_wt).to_i, :end => (current_day+max_wt).to_i, :editable => false}
      wh = @worker.working_hours.where(:week_day => [1,2,3,4,5,6,0][index % 7] ).first
      @periods << if Time.zone.now.to_date + @organization.last_day.to_i.days <= (current_day).to_date
        if wh && (@worker.working_days.count.zero? || @worker.working_days.where(:date => current_day).count > 0)
          res = []
          res << { :title => 'Закрыто', :start => (current_day+min_wt).to_i, :end => (current_day+wh.begin_time).to_i, :editable => false, 'data-inner-class' => 'legend-inaccessible' } if min_wt != wh.begin_time
          res << { :title => 'Закрыто', :start => (current_day+wh.end_time).to_i, :end => (current_day+max_wt).to_i, :editable => false, 'data-inner-class' => 'legend-inaccessible' } if wh.end_time != max_wt
          res
        else
          { :title => 'Выходной', 'data-inner-class' => 'legend-inaccessible' }.merge( full_day )
        end
      else
        { :title => "Запись невозможна", 'data-inner-class' => 'legend-old-day' }.merge( full_day )
      end
    end
    respond_with( @periods.flatten.compact )
  end

  private

    def find_worker
      @worker = Worker.find(params[:worker_id])
    end

end
