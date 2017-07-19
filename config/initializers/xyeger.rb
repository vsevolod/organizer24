Xyeger.configure do |config|
  config.formatter = Xyeger::Formatters::Values.new(colored: true)
end

Sidekiq::Logging.logger.formatter = Xyeger::Formatters::SidekiqJson.new
