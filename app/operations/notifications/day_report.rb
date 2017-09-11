module Operations
  module Notifications
    class DayReport
      attr_reader :organization, :except_ids
      attr :worker, :appointments, :month_appointments

      def initialize(options)
        @organization = Organization.find(options[:organization_id])
        @except_ids = options[:except_ids] || []
      end

      def call
        Time.zone = @organization.timezone
        @except_ids << worker.id

        enqueue

        send
      end

      def send
        notification = Notification.new(
          notification_type: 'sms',
          user: worker.user,
          worker: worker,
          organization: organization
        )
        sms = Smsru.new(text, worker.phone)

        notification.cost, notification.length = sms.get_cost
        notification.save

        sms.set_notification notification
        sms.send
      end

      def text
        result = []
        if appointments.any?
          result << "За сегодня (#{Russian.strftime(today, '%d.%m.%y')}) Вы заработали: #{appointments.sum(:cost)} р." 
        end
        if today.to_date == today.to_date.at_end_of_month
          result << "За месяц ваш заработок составил: #{month_appointments.sum(:cost)} р."
        end
        result.join("\n")
      end

      def worker
        @worker ||= workers.where.not(id: except_ids).take
      end

      def enqueue
        if except_ids.size < workers.count
          SmsJob.perform_later({ organization_id: organization.id, except_ids: except_ids }, 'day_report')
        else
          SmsJob.set(wait_until: next_time).perform_later({ organization_id: organization.id }, 'day_report')
        end
      end

      private

      def workers
        @organization.workers.enabled.order('phone, name')
      end

      def next_time
        next_day = 1.day.since.at_beginning_of_day
        end_time = organization.working_hours.where(week_day: next_day.wday).maximum(:end_time)
        next_day + end_time + 1.hour
      end

      def appointments
        @appointments ||=
          begin
            worker.appointments.where(start: today..(today + 1.day), status: %w[complete lated])
          end
      end

      def month_appointments
        @month_appointments ||=
          begin
            worker.appointments.where(start: today.at_beginning_of_month..today.at_end_of_month, status: %w[complete lated])
          end
      end

      def today
        Time.current.at_beginning_of_day
      end
    end
  end
end
