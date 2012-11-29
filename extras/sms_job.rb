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
      @sender = @appointment.organization
      sms.text = <<-TEXT
      Здравствуйте #{@appointment.firstname}. #{GENITIVE_WEEK_DAYS[@appointment.start.wday]} #{Russian.strftime( @appointment.start, "%d %B в %H:%M" )} Вы записаны к Золотаревой Анне на следующие услуги: #{@appointment.services.order(:name).pluck(:name).join(', ')}. Продолжительность приема: #{@appointment.showing_time.show_time}, Стоимость: #{@appointment.cost} руб.
      TEXT
    when 'confirmation_number'
      user = User.find(options[:user_id])
      sms.text = <<-TEXT
      Ваш код подтверждения: #{user.confirmation_number}
      TEXT
    end.strip
    sms.send
  end
end
