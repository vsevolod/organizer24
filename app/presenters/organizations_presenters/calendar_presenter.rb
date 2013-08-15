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
        minTime  = organization.working_hours.pluck(:begin_time).min
        maxTime  = organization.working_hours.pluck(:end_time).max
        sminutes = (organization.slot_minutes || 30).to_i
        @calendar_settings = {:slotMinutes => sminutes, :minTime => minTime, :maxTime => maxTime, :organization_id => organization.id, :initial_date => initial_date}
      end
    end

    def owner_or_worker?
      @owner_or_worker ||= @current_user.owner_or_worker?(organization)
    end

    private

      def initial_date
        if @day
          Time.zone.at(@day.to_i)
        else
          Time.now
        end.to_i*1000
      end

  end
end
