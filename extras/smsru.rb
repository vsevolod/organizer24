# coding: utf-8
class Smsru

  attr_writer :options

  attr_accessor :sender, :recipient, :text

  def initialize( text = '', recipient = nil, sender = nil )
    @options = YAML.load_file('config/smsru.yml')
    @text = text
    @recipient = recipient || @options['login']
    @sender = sender || @options['login']
  end

  # with api_id
  def send
    uri = URI('http://sms.ru/sms/send')
    # TODO добавить "from" и обработку ответа
    res = Net::HTTP.post_form(uri, {:api_id => @options['api_id'], :to => @recipient, :text => @text}) unless @text.blank?
    puts "================================="
    puts "SENDER: #{@sender}"
    puts "RECIPIENT: #{@recipient}"
    puts "TEXT: #{@text}"
    puts "================================="
  end

end
