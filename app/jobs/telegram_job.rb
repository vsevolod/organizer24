class TelegramJob < ApplicationJob
  queue_as :default

  def perform(options)
    uri = URI("https://api.telegram.org/bot#{ENV['TELEGRAM_FULL_TOKEN']}/sendMessage")
    return if options[:message].blank?

    Rails.logger.info "===== Send to Telegram =====: #{options}"
    Net::HTTP.post_form(
      uri,
      chat_id: options[:telegram_id],
      text: options[:message]
    )
  end
end
