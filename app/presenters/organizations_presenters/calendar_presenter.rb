module OrganizationsPresenters
  class CalendarPresenter

    def initialize( options )
      @day = options[:day]
      @worker_id = options[:worker_id]
      @organization = options[:organization]
      @current_user = options[:current_user] || User.new
    end

    def phonebook
      if @current_user.owner?( @organization )
        @phonebook ||= @organization.appointments.select("DISTINCT(phone), MAX(firstname) as firstname, MAX(lastname) as lastname").group("phone")
      end
    end

    def phonebook_to_json
      @phonebook_to_json ||= phonebook.to_json(:only => [:phone, :firstname, :lastname])
    end

    def str_day
      if @day
        @str_day ||= (Time.zone.at(@day.to_i) - 1.month).strftime("%Y, %m, %d")
      end
    end

    def enabled_workers
      @enabled_workers ||= @organization.workers.enabled.order(:updated_at)
    end

    def worker
      @worker ||= enabled_workers.where(:id => @worker_id).first || ( @current_user ? @current_user.worker : nil)
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

    def worker_services
      @worker_services ||= get_worker.services.not_collections.order(:show_by_owner, :name)
    end

    def organization
      @organization
    end

  end
end
