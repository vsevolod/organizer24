# coding: utf-8
class WorkingHoursController < CompanyController
  before_filter :prepare_calendar_options

  respond_to :html, :json

  # TODO move to appointment controller
  def self_by_month
    @periods = []
    @start_of_month = @start.at_beginning_of_month.to_date
    @start = Date.today if @start < Date.today

    @appointments = if current_user.owner?( @organization )
                      @organization.appointments
                    else
                      current_user.appointments.where(:organization_id => @organization.id).where( :status.in => %w{approve offer taken} )
                    end.where(:start.gteq => @start, :start.lteq => @end)
    @appointments.each do |appointment|
      data_inner_class = if appointment.offer?
                           'legend-your-offer'
                         else
                           'legend-inaccessible'
                         end
      @periods << { :title => appointment.aasm_human_state, :start => appointment.start.to_i, :end => (appointment.start + appointment.showing_time.minutes).to_i, :editable => false, 'data-inner-class' => data_inner_class, 'data-id' => appointment.id }
    end
    if current_user.owner?( @organization )
      (@end.to_date-@start_of_month).to_i.times do |day|
        if @start_of_month+day == (@start_of_month+day).at_end_of_month && @start_of_month+day < Date.today
          cost = @organization.appointments.where(:start.gteq => (@start_of_month+day).at_beginning_of_month, :start.lteq => @start_of_month+(1+day).day).where( :status => ['complete', 'lated'] ).sum(:cost)
          @periods << {:title => "Итог за месяц:#{cost}", :allDay => true, :start => @start_of_month+day.day}
        end
        next if @start_of_month+day > Date.today
        cost = @organization.appointments.where(:start.gteq => @start_of_month+day.day, :start.lteq => @start_of_month+(1+day).day).where( :status => ['complete', 'lated'] ).sum(:cost)
        next if cost.zero?
        @periods << {:title => "Итог:#{cost}", :allDay => true, :start => @start_of_month+day.day}
      end
    end
    respond_with( @periods )
  end

  def by_week
    min_wt = @organization.working_hours.pluck(:begin_time).min
    max_wt = @organization.working_hours.pluck(:end_time).max
    @worker = get_worker
    @periods = []
    [1,2,3,4,5,6,0].each_with_index do |t, index|
      full_day = {:start => (@start+index.days+min_wt).to_i, :end => (@start+index.days+max_wt).to_i, :editable => false}
      wh = @organization.working_hours.where(:week_day => t ).first
      @periods << if Time.zone.now.to_date + @organization.last_day.to_i.days <= (@start + index.days).to_date
        if wh && (@worker.working_days.count.zero? || @worker.working_days.where(:date => @start + index.days).count > 0)
          res = []
          res << { :title => 'Закрыто', :start => (@start+index.days+min_wt).to_i, :end => (@start+index.days+wh.begin_time).to_i, :editable => false, 'data-inner-class' => 'legend-inaccessible' } if min_wt != wh.begin_time
          res << { :title => 'Закрыто', :start => (@start+index.days+wh.end_time).to_i, :end => (@start+index.days+max_wt).to_i, :editable => false, 'data-inner-class' => 'legend-inaccessible' } if wh.end_time != max_wt
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

end
