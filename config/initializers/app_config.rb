unless defined?(APP_CONFIG)
  APP_CONFIG = YAML.load_file("#{File.dirname(__FILE__)}/../config.yml")[Rails.env]
end
