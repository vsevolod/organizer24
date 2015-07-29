# coding: utf-8
class WorkingHoursController < CompanyController
  before_filter :prepare_calendar_options
  before_filter :need_to_login, :only => :self_by_month #TODO может заменить на более популярный метод?
  before_filter :find_worker, :except => :self_by_month

  respond_to :html, :json

  # TODO move to appointment controller
  def self_by_month
    @periods = []
    @start_of_month = @start.at_beginning_of_month.to_date
    @start = Date.today if @start < Date.today

    @total_appointments = if current_user.owner? @organization
                            @organization.appointments
                          elsif current_user.worker? @organization
                            current_user.worker(@organization).appointments
                          end
    @appointments = (@total_appointments || current_user.appointments.where(:organization_id => @organization.id).where( :status.in => %w{approve offer taken} )).where(:start.gteq => @start, :start.lteq => @end)
    @appointments.each do |appointment|
      data_inner_class = if appointment.offer?
                           'legend-your-offer'
                         else
                           'legend-inaccessible'
                         end
      @periods << { :title => (appointment.comment.present? ? "<b>#{appointment.comment}</b>" : appointment.human_state), :start => appointment.start.iso8601, :end => appointment._end.iso8601, :editable => false, 'data-inner-class' => data_inner_class, 'data-id' => appointment.id }
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
    # Находим границы календаря
    # TODO: Подумать, что сделать с double_rates, которые далеко впереди
    #double_rates = @worker.double_rates.where('week_day IS NOT NULL OR (day >= :start AND day <= :end)', {start: @start.localtime.to_date, end: @end.localtime.to_date})
    double_rates = @worker.organization.double_rates.where('day IS NULL OR day >= ?', Time.now - 1.day)
    min_wt = (@worker.organization.working_hours.pluck(:begin_time) + double_rates.pluck(:begin_time)).min.to_i
    max_wt = (@worker.organization.working_hours.pluck(:end_time)   + double_rates.pluck(:end_time)).max.to_i

    @worker = get_worker
    # Подсчет мультипликаторов
    rates = @worker.double_rates.where('date(day) >= :start AND date(day) <= :end OR week_day IS NOT NULL', {start: @start, end: @end})
    @periods = []
    ((@start.to_date)..(@end.to_date)).each_with_index do |t, index|
      current_day = @start + index.days
      whs = @worker.working_hours.where(:week_day => [1,2,3,4,5,6,0][index % 7] ).order(:begin_time)
      double_rates = rates.where('week_day = :week_day OR day = :current_day', {week_day: current_day.wday, current_day: current_day.localtime.to_date})
      @periods << if Time.zone.now.to_date + @organization.last_day.to_i.days <= (current_day).to_date
        double_rates.map do |double_rate|
          @periods.push({rate: double_rate.rate, :start => (current_day+double_rate.begin_time.to_i).iso8601, :end => (current_day+double_rate.end_time.to_i).iso8601, :editable => false, title: "Тариф: x#{double_rate.rate}", 'data-inner-class' => 'legend-rate'})
        end if (@worker.working_days.count.zero? || @worker.working_days.where(:date => current_day.to_date).count > 0)
        if whs.any? && (@worker.working_days.count.zero? || @worker.working_days.where(:date => current_day.to_date).count > 0)
          closes = [min_wt]
          whs.each do |wh|
            closes.push(wh.begin_time)
            closes.push wh.end_time
          end
          closes.push max_wt
          prepared = closes.each_slice(2).find_all{|x| x.first != x.last}
          prepared.exclude!(double_rates.map{|dr| [dr.begin_time, dr.end_time]}).find_all{|x| x.first != x.last}.map do |arr|
            { title: 'Закрыто',
              start: (current_day + arr.first).iso8601,
              end:   (current_day + arr.last).iso8601,
              editable: false,
              'data-inner-class' => 'legend-inaccessible'
            }
          end
        else
          tarr = [[min_wt, max_wt]]
          tarr = tarr.exclude!(double_rates.map{|dr| [dr.begin_time, dr.end_time]}) if (@worker.working_days.count.zero? || @worker.working_days.where(:date => current_day.to_date).count > 0)
          tarr.find_all{|x| x.first != x.last}.map do |arr|
            { title: 'Закрыто',
              start: (current_day + arr.first).iso8601,
              end:   (current_day + arr.last).iso8601,
              editable: false,
              'data-inner-class' => 'legend-inaccessible'
            }
          end
        end
      else
        { :title => "Запись невозможна", 'data-inner-class' => 'legend-old-day' }.merge({:start => (current_day+min_wt).iso8601, :end => (current_day+max_wt).iso8601, :editable => false})
      end
    end
    respond_with( @periods.flatten.compact )
  end

end
