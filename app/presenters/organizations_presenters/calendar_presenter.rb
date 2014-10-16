module OrganizationsPresenters
  class CalendarPresenter

    def initialize( options )
      @day = options[:day]
      @worker_id = options[:worker_id]
      @organization = options[:organization]
      @current_user = options[:current_user] || User.new
    end

    def phonebook
      if owner_or_worker?
        @phonebook ||= @organization.appointments.select("DISTINCT(phone), MAX(firstname) as firstname, MAX(lastname) as lastname").group("phone")
      end
    end

    def phonebook_to_json
      @phonebook_to_json ||= phonebook.to_json(:only => [:phone, :firstname, :lastname])
    end

    def enabled_workers
      @enabled_workers ||= @organization.workers.enabled.order(:updated_at)
    end

    def worker
      @worker ||= enabled_workers.where(:id => @worker_id).first || (@current_user ? @current_user.worker(organization) : nil)
    end

    def show_workers
      @show_workers ||= enabled_workers.size > 1 && !worker
    end

    def get_worker
      @get_worker ||= worker || enabled_workers.first
    end

    def organization_services
      @organization_services ||= @organization.get_services( @current_user.phone ).to_json
    end

    def organization
      @organization
    end

    def calendar_settings
      if @calendar_settings
        @calendar_settings
      else
        # TODO: Подумать, что сделать с double_rates, которые далеко впереди
        double_rates = organization.double_rates.where('day IS NULL OR day >= ?', Time.now - 1.day)
        minTime  = (organization.working_hours.pluck(:begin_time) + double_rates.pluck(:begin_time)).min.to_i
        maxTime  = (organization.working_hours.pluck(:end_time)   + double_rates.pluck(:end_time)).max.to_i
        duration = (organization.slot_minutes || 30).to_i.minutes
        @calendar_settings = {
          minTime: minTime.to_moment,
          maxTime: maxTime.to_moment,
          organization_id: organization.id,
          initial_date: (@day ? Time.zone.at(@day.to_i) : Time.zone.now).iso8601,
          now: Time.zone.now.iso8601,
          duration: duration.to_moment
        }
      end
    end

    def owner_or_worker?
      @owner_or_worker ||= @current_user.owner_or_worker?(organization)
    end

  end
end
