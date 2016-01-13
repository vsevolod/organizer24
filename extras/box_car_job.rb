# coding: utf-8
require 'net/http'

class BoxCarJob < Struct.new(:options)

  def perform
    uri = URI('https://new.boxcar.io/api/notifications')
    unless options[:message].blank?
      Net::HTTP.post_form(uri, {
        'notification[title]' => 'depilate.ru',
        'notification[long_message]' => options[:message].gsub("\n", "</br>"),
        'notification[sound]' => 'Done',
        'notification[source_name]' => 'oneclickbook',
        user_credentials: options[:authentication_token]
      })
      #binding.pry
    end
  end

end
