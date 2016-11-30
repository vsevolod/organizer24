require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Organizer
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths << Rails.root.join('extras')
    config.autoload_paths << Rails.root.join('app', 'models', 'ckeditor')
    config.autoload_paths << Rails.root.join('app', 'graph')
    config.autoload_paths << Rails.root.join('app', 'graph', 'types')
    config.autoload_paths << Rails.root.join('app', 'presenters')

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    config.time_zone = 'Krasnoyarsk'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :ru
    config.encoding = 'utf-8'
    config.filter_parameters +=[:password]

    config.active_job.queue_adapter = :sidekiq

    # Allow Cross-Origin Resource Sharing for Rack
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        if Rails.env.development?
          origins 'localhost:3000', '127.0.0.1:3000'
        else
          origins Regexp.new("^(" + Organization.pluck(:domain).join('|') + ")\\.")
        end
        resource '/api/*', :headers => :any, :methods => [:get, :post, :options]
      end
    end
  end
end
