Xyeger.configure do |config|
  config.output = STDOUT                      # default to STDOUT
  config.formatter = Xyeger::Formatters::Values.new
  config.app = 'Organizer'                    # default to ENV['XYEGER_APPNAME'] or emtpy string
  config.env = Rails.env                      # default to ENV['XYEGER_ENV'] or empty string
end
