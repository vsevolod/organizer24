require 'themed_text'
class SmsJob < ApplicationJob
  queue_as :default

  def perform(options, sms_type)
    sms = Smsru.new # @appointment.phone, @organization.user.phone
    notification = Notification.new(notification_type: 'sms')
    case sms_type
    when 'day_report'
      @organization = Organization.find(options[:organization_id])
      except_ids = options[:except_ids] || [0]
      Time.zone = @organization.timezone
      @worker = @organization.workers.order('phone, name').where('id NOT IN (?)', except_ids).first
      except_ids << @worker.id
      today = Time.zone.now.at_beginning_of_day
      @appointments = @worker.appointments.where(start: today..(today + 1.day), status: %w(complete lated))
      sms.recipient = @worker.phone
      notification.user = @worker.user
      notification.worker = @worker
      notification.organization = @organization
      sms.text = "За сегодня (#{Russian.strftime(today, '%d.%m.%y')}) Вы заработали: #{@appointments.sum(:cost)} р." if @appointments.any?
      if today.to_date == today.to_date.at_end_of_month
        @appointments = @worker.appointments.where(start: (today.at_beginning_of_month)..(today.at_end_of_month), status: %w(complete lated))
        sms.text += "\nЗа месяц ваш заработок составил: #{@appointments.sum(:cost)} р."
      end
      working_hours = @organization.working_hours.order(:week_day)
      next_working_hour = working_hours.where(week_day: Date.today.next.cwday...8).first || working_hours.first
      next_day = Date.today + ((next_working_hour.week_day - Date.today.cwday + 7) % 7).day # Следующий день. когда надо уведомлять
      next_day += 1.day if next_day == Date.today
      next_time = (next_day.in_time_zone + next_working_hour.end_time) + 1.hour  # Дата и время для уведомления
      unless options[:except_ids]
        SmsJob.set(wait_until: next_time).perform_later({ organization_id: options[:organization_id] }, 'day_report')
      end
      if @organization.workers.where.not(id: except_ids).count > 0
        SmsJob.perform_later({ organization_id: options[:organization_id], except_ids: except_ids }, 'day_report')
      end
    when 'notification'
      # Надо Time.zone объявить до того, как найдем appointment
      Time.zone = Organization.joins(:appointments).where(appointments: { id: options[:appointment_id] }).first.timezone
      @appointment = Appointment.find(options[:appointment_id])
      @organization = @appointment.organization
      notification.appointment = @appointment
      notification.worker = @appointment.worker
      notification.user = @appointment.user_by_phone
      notification.organization = @organization
      sms.recipient = @appointment.phone
      sms.text = themed_text(:user_notify, @organization.user_notify_text, @appointment)
      case @organization.domain
      when 'depilate'
        sms.sender = 'depilate.ru'
      end
    when 'confirmation_number'
      user = User.find(options[:user_id])
      sms.recipient = user.phone
      notification.user = user
      notification.organization = user.find_organization
      sms.text = "Ваш код подтверждения: #{user.confirmation_number}"
    when 'simple_notify'
      sms.recipient = options[:phone]
      sms.text = options[:text]
    end
    notification.user ||= User.find_by(phone: options[:phone])
    notification.worker ||= notification.user.worker
    notification.organization ||= notification.user.find_organization
    notification.cost, notification.length = sms.get_cost
    notification.save
    sms.set_notification notification
    sms.send
  end

end
