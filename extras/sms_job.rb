# coding: utf-8
# TODO Добавить в организацию адрес для уведомлений
require 'net/http'
require 'themed_text'

class SmsJob < Struct.new(:options, :sms_type)

  GENITIVE_WEEK_DAYS = ['', 'В понедельник', 'Во вторник', 'В среду', 'В четверг', 'В пятницу', 'В субботу', 'В воскресенье']

  def perform
    sms = Smsru.new( ) #@appointment.phone, @organization.user.phone
    case sms_type
    when 'day_report'
      @organization = Organization.find(options[:organization_id])
      Time.zone = @organization.timezone
      today = Time.zone.now.at_beginning_of_day
      @appointments = Organization.first.appointments.where(:start.gteq => today, :start.lteq => today+1.day).where( :status => ['complete', 'lated'] )
      sms.recipient = @organization.owner.phone
      sms.text = "За сегодня (#{Russian.strftime(today, "%d.%m.%y")}) Вы заработали: #{@appointments.sum(:cost)} р." if @appointments.any?
      if today.to_date == today.to_date.at_end_of_month
        @appointments = Organization.first.appointments.where(:start.gteq => today.at_beginning_of_month, :start.lteq => today.at_end_of_month).where( :status => ['complete', 'lated'] )
        sms.text += "\nЗа месяц ваш зароботок составил: #{@appointments.sum(:cost)} р."
      end
      working_hours = @organization.working_hours.order(:week_day)
      next_working_hour = working_hours.where(:week_day.gt => Date.today.cwday).first || working_hours.first
      next_day = Date.today + ( (next_working_hour.week_day - Date.today.cwday + 7)%7 ).day # Следующий день. когда надо уведомлять
      next_time = (next_day.to_time_in_current_zone + next_working_hour.end_time) + 1.hour  # Дата и время для уведомления
      Delayed::Job.enqueue SmsJob.new( { :organization_id => options[:organization_id] }, 'day_report' ), :run_at => next_time
    when 'notification'
      # Надо Time.zone объявить до того, как найдем appointment
      Time.zone = Organization.joins(:appointments).where( :appointments => { :id => options[:appointment_id] } ).first.timezone
      @appointment = Appointment.find( options[:appointment_id] )
      @organization = @appointment.organization
      sms.recipient = @appointment.phone
      sms.text = themed_text( :user_notify, @organization.user_notify_text, @appointment )
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
