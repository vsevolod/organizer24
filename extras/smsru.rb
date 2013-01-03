# coding: utf-8
class Smsru

  DEFAULT_PHONE_NUMBER = '9131991854'

  attr_writer :options

  attr_accessor :sender, :recipient, :text

  def initialize( text = '', recipient = DEFAULT_PHONE_NUMBER, sender = DEFAULT_PHONE_NUMBER )
    @options = YAML.load_file('config/smsru.yml')
    @text = text
    @recipient = recipient
    @sender = sender
  end

  # with api_id
  def send
    uri = URI('http://sms.ru/sms/send')
    # TODO добавить "from" и обработку ответа
    res = Net::HTTP.post_form(uri, :api_id => @options['api_id'], :to => @recipient, :text => @text+"\nСайт: depilate.ru" )
    puts "SENDER: #{@sender}"
    puts "RECIPIENT: #{@recipient}"
    puts "TEXT: #{@text}"
    puts "================================="
  end

end
