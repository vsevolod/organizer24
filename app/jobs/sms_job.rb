require 'themed_text'
class SmsJob < ApplicationJob
  queue_as :default

  def perform(options, sms_type)
    sms = Smsru.new # @appointment.phone, @organization.user.phone
    notification = Notification.new(notification_type: 'sms')
    case sms_type
    when 'day_report'
      return Operations::Notifications::DayReport.new(options).call
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
