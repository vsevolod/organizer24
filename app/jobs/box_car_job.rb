class BoxCarJob < ApplicationJob
  queue_as :default

  def perform(options)
    uri = URI('https://new.boxcar.io/api/notifications')
    unless options[:message].blank?
      Rails.logger.info "===== Send to BoxCar =====: #{options}"
      Net::HTTP.post_form(uri, 'notification[title]' => 'depilate.ru',
                               'notification[long_message]' => options[:message].gsub("\n", '</br>'),
                               'notification[sound]' => 'Done',
                               'notification[source_name]' => 'oneclickbook',
                               user_credentials: options[:authentication_token])
    end
  end
end
