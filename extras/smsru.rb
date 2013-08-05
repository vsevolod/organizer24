# coding: utf-8
class Smsru

  attr_writer :options

  attr_accessor :sender, :recipient, :text

  def initialize( text = '', recipient = nil, sender = '1clickbook' )
    @options = APP_CONFIG['smsru']
    @text = text
    @recipient = recipient || @options['login']
    @sender = sender || @options['login']
  end

  # with api_id
  def send
    uri = URI('http://sms.ru/sms/send')
    res = Net::HTTP.post_form(uri, {:api_id => @options['api_id'], :to => @recipient, :text => @text, :from => @sender}) unless @text.blank?
    puts "================================="
    puts "SENDER: #{@sender}"
    puts "RECIPIENT: #{@recipient}"
    puts "TEXT: #{@text}"
    puts "================================="
  end

end
