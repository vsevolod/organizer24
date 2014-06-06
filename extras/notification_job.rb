require 'net/http'
require 'themed_text'

class NotificationJob < Struct.new(:notification_id, :options)

  def perform
    @notification = Notification.find(notification_id)
    @options = self.options || {}
    @try = @options[:try] || 1
    case @options[:method]
    when :check then check # Проверить статус сообщения
    end
  end

  def check
    sms = Smsru.new
    sms.set_notification(@notification)
    status = sms.check_sms_status(@options[:id])
    case status
    when 103
      if @notification.organization && @notification.organization.sms_ru
        if new_balance = sms.get_balance
          @notification.organization.sms_ru.update_attribute(:balance, new_balance)
        end
      end
      @notification.completed!
    when 104..211, 300..302
      @notification.canceled!
    else
      @try += 1
      Delayed::Job.enqueue NotificationJob.new(notification_id, {method: 'check', try: @try, id: @options[:id]}), run_at: Time.now + (@try*30).minutes
    end
  end

end
