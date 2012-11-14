# coding: utf-8
# TODO Добавить в организацию адрес для уведомлений
require 'net/http'

class SmsJob < Struct.new(:appointment_id, :sms_type)

  GENITIVE_WEEK_DAYS = ['', 'В понедельник', 'Во вторник', 'В среду', 'В четверг', 'В пятницу', 'В субботу', 'В воскресенье']

  def perform
    @appointment = Appointment.find( appointment_id )
    @sender = @appointment.organization
    text = case sms_type
           when 'notification'
             <<-TEXT
             Здравствуйте #{@appointment.firstname}. #{GENITIVE_WEEK_DAYS[@appointment.start.wday]} #{Russian.strftime( @appointment.start, "%d %B в %H:%M" )} Вы записаны на следующие услуги: #{@appointment.services.order(:name).pluck(:name).join(', ')}. Продолжительность приема: #{@appointment.showing_time.show_time}, Стоимость: #{@appointment.cost} руб.
             TEXT
           end.strip
    sms = Smsru.new( text ) #@appointment.phone, @organization.user.phone
    sms.send
  end
end
