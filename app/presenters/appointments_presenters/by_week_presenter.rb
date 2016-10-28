module AppointmentsPresenters
  class ByWeekPresenter
    def initialize(current_user, organization, statuses, _start, _end, worker)
      @current_user = current_user || User.new
      @organization = organization
      @statuses = statuses
      @start = _start.to_date
      @end = _end.to_date
      @worker = worker

      @user_services = {}
    end

    def render
      @render ||= joins(render_periods)
    end

    private

    def appointments
      @appointments ||= if is_owner?
                          @worker.appointments.where(status: @statuses)
                        else # Обычный пользователь просматривает только все что >= сегодняшнего дня
                          @worker.appointments.where.not(status: %W(free cancel_owner cancel_client missing)).where('date(start) >= ?', Time.zone.now.to_date)
                        end.where('date(start) >= ? AND date(start) < ?', @start, @end)
    end

    def render_periods
      @periods = appointments.includes(:services).map do |appointment|
        editable = is_owner? || (appointment.phone == @current_user.phone && appointment.starting_state?) # FIXME: заменить после на appointment.user == @current_user
        title = if editable && appointment.starting_state?
                  appointment.services.map(&:name).join('<br/>')
                else
                  appointment.aasm.human_state
                end
        options = { title: title,
                    start: appointment.start.iso8601utc,
                    end:   appointment._end.iso8601utc,
                    editable: false,
                    splitted: false,
                    is_owner: is_owner?,
                    notification: appointment.notifications.order('updated_at DESC').first_or_initialize.status,
                    'data-cost' => appointment.cost,
                    'data-inner-class' => 'legend-taken',
                    'data-showing-time' => appointment.showing_time,
                    'data-id' => appointment.id}
        if is_owner?
          options['data-comment'] = appointment.comment
        end
        if editable
          options.merge(:splitted => true,
                          'data-inner-class' => 'legend-your-offer',
                          'data-client' => "#{appointment.fullname} #{appointment.phone}",
                          'data-id' => appointment.id,
                          'data-services' => organization_user_services(appointment).to_json(only: [:name, :cost, :showing_time]))
        else
          options
        end
      end
    end

    def joins(prepare_periods)
      if is_owner?
        prepare_periods
      else
        prepare_periods.dup.each_with_index do |_this, index|
          next unless _this && !_this[:splitted] && ( _next = prepare_periods.find{|p| p && p[:start] == _this[:end] && !p[:splitted]})
            _next[:start] = _this[:start]
            _next['data-showing-time'] += _this['data-showing-time']
            prepare_periods[index] = nil
        end
        prepare_periods.compact
      end
    end

    def is_owner?
      @is_owner ||= @current_user.owner_or_worker?(@organization)
    end

    def add_to_user_services(phone)
      @user_services[phone] ||= @organization.get_services(phone, :normal)
    end

    def organization_user_services(appointment)
      services = @user_services[appointment.phone] || add_to_user_services(appointment.phone)
      services_users = services.find_all { |arr| (arr.first & appointment.service_ids).any? }
      services_users.map do |ids, cost, showing_time|
        service = Service.find(ids.first)
        service.cost = cost
        service.showing_time = showing_time
        service
      end
    end
  end
end
