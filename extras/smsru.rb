# coding: utf-8
class Smsru

  attr_accessor :sender, :recipient, :text, :notification

  def initialize( text = '', recipient = nil, sender = '1clickbook' )
    @text = text
    @recipient = recipient || get_options['login']
    @sender = sender || get_options['login']
  end

  # with api_id
  def send
    uri = URI('http://sms.ru/sms/send')
    unless @text.blank?
      res = Net::HTTP.post_form(uri, {:api_id => get_options['api_id'], :to => @recipient, :text => @text, :from => @sender})
      result = res.body.split("\n")
      case result.shift
      when '100'
        notification.sended!
        Delayed::Job.enqueue NotificationJob.new(notification.id, method: :check, id: result.first), run_at: Time.now + 5.minutes
      end
    end
  end

  def get_cost
    uri = URI('http://sms.ru/sms/cost')
    unless @text.blank?
      res = Net::HTTP.post_form(uri, {:api_id => get_options['api_id'], :to => @recipient, :text => @text})
      result = res.body.split("\n")
      if result.shift == '100'
        result
      end
    end
  end

  def self.check_sms_status(id)
    uri = URI('http://sms.ru/sms/status')
    res = Net::HTTP.post_form(uri, {api_id: get_options['api_id'], id: id})
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
