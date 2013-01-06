# coding: utf-8
# TODO Добавить в организацию адрес для уведомлений
require 'net/http'

class SmsJob < Struct.new(:options, :sms_type)

  GENITIVE_WEEK_DAYS = ['', 'В понедельник', 'Во вторник', 'В среду', 'В четверг', 'В пятницу', 'В субботу', 'В воскресенье']

  def perform
    sms = Smsru.new( ) #@appointment.phone, @organization.user.phone
    case sms_type
    when 'notification'
      @appointment = Appointment.find( options[:appointment_id] )
      Time.zone = @appointment.organization
      sms.recipient = @appointment.phone
      sms.text = (<<-TEXT).strip
      Здравствуйте #{@appointment.firstname}. #{GENITIVE_WEEK_DAYS[@appointment.start.wday]} #{Russian.strftime( @appointment.start, "%d %B в %H:%M" )} Вы записаны к Золотаревой Анне на следующие услуги: #{@appointment.services.order(:name).pluck(:name).join(', ')}. Продолжительность приема: #{@appointment.showing_time.show_time}, Стоимость: #{@appointment.cost} руб.
      TEXT
    when 'confirmation_number'
      user = User.find(options[:user_id])
      sms.recipient = user.phone
      sms.text = "Ваш код подтверждения: #{user.confirmation_number}"
    when 'notify_owner'
      sms.recipient = options[:phone]
      sms.text = options[:text]
    end
    sms.send
  end
end
