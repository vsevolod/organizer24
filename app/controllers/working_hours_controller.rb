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
      @periods << { :title => (appointment.comment.present? ? "<b>#{appointment.comment}</b>" : appointment.aasm_human_state), :start => appointment.start.iso8601, :end => appointment._end.iso8601, :editable => false, 'data-inner-class' => data_inner_class, 'data-id' => appointment.id }
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
    min_wt = @worker.organization.working_hours.pluck(:begin_time).min.to_i
    max_wt = @worker.organization.working_hours.pluck(:end_time).max.to_i
    @worker = get_worker
    @periods = []
    ((@start.to_date)..(@end.to_date)).each_with_index do |t, index|
      current_day = @start + index.days
      full_day = {:start => (current_day+min_wt).iso8601, :end => (current_day+max_wt).iso8601, :editable => false}
      whs = @worker.working_hours.where(:week_day => [1,2,3,4,5,6,0][index % 7] ).order(:begin_time)
      @periods << if Time.zone.now.to_date + @organization.last_day.to_i.days <= (current_day).to_date
        if whs.any? && (@worker.working_days.count.zero? || @worker.working_days.where(:date => current_day.to_date).count > 0)
          closes = [min_wt]
          whs.each do |wh|
            closes.push(wh.begin_time)
            closes.push wh.end_time
          end
          closes.push max_wt
          res = []
          closes.map{|x| current_day+x}.each_slice(2).find_all{|x| x.first != x.last}.each do |arr|
            res << { title: 'Закрыто',
                     start: arr.first.iso8601,
                     end:   arr.last.iso8601,
                     editable: false,
                     'data-inner-class' => 'legend-inaccessible'
                   }
          end
          #begin_time = whs.pluck(:begin_time).min
          #end_time   = whs.pluck(:end_time).max
          #res = []
          #res << { :title => 'Закрыто', :start => (current_day+min_wt).to_i, :end => (current_day+begin_time).to_i, :editable => false, 'data-inner-class' => 'legend-inaccessible' } if min_wt != begin_time
          #res << { :title => 'Закрыто', :start => (current_day+end_time).to_i, :end => (current_day+max_wt).to_i, :editable => false, 'data-inner-class' => 'legend-inaccessible' } if end_time != max_wt
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
