# coding: utf-8
class Smsru

  attr_accessor :sender, :recipient, :text, :notification, :api_id, :translit

  def initialize( text = '', recipient = nil, sender = nil )
    @text = text
    @recipient = recipient
    @sender = sender
  end

  # TODO ужас этот убрать. подумать как сделать правильно
  def set_notification(notification)
    @notification = notification
    @recipient ||= notification.organization ? notification.organization.sms_ru.try(:phone)  : get_options['phone']
    @sender    ||= notification.organization ? notification.organization.sms_ru.try(:sender) : get_options['sender']
    @api_id      = notification.organization ? notification.organization.sms_ru.try(:api_id) : get_options['api_id']
    @translit    = notification.worker ? (notification.worker.sms_translit ? '1' : '0') : (notification.organization && notification.organization.sms_ru.try(:translit) ? '1' : '0')
  end

  # with api_id
  def send
    uri = URI('http://sms.ru/sms/send')
    unless @text.blank?
      res = Net::HTTP.post_form(uri, {:api_id => @api_id, :to => @recipient, :text => @text, :from => @sender, partner_id: get_options[:partner_id], translit: @translit})
      result = res.body.split("\n")
      case status = result.shift
      when '100'
        notification.sended!
        Delayed::Job.enqueue NotificationJob.new(notification.id, method: :check, id: result.first), run_at: Time.now + 5.minutes
      else
        raise "SMS SEND ERROR: #{status}"
      end
    end
  end

  def get_balance
    uri = URI('http://sms.ru/my/balance')
    res = Net::HTTP.post_form(uri, {:api_id => @api_id})
    result = res.body.split("\n")
    if result.shift == '100'
      result[0]
    end
  end

  def get_cost
    uri = URI('http://sms.ru/sms/cost')
    unless @text.blank?
      res = Net::HTTP.post_form(uri, {:api_id => @api_id, :to => @recipient, :text => @text})
      result = res.body.split("\n")
      if result.shift == '100'
        result
      end
    end
  end

  def check_sms_status(id)
    uri = URI('http://sms.ru/sms/status')
    res = Net::HTTP.post_form(uri, {api_id: @api_id, id: id})
    res.body.to_i
  end

  private

    def get_options
      @options ||= Smsru.get_options
    end

    def self.get_options
      @options ||= APP_CONFIG['smsru']
    end

end
