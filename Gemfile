source 'https://rubygems.org'
source 'https://rails-assets.org'

#gem 'rails', '4.2.7'
gem 'rails', '5.0.5'

gem 'cocoon'
gem 'event-calendar', require: 'event_calendar'

gem 'haml'
gem 'simple_form'
gem 'russian'
gem 'ckeditor'
gem 'paperclip'
gem 'will_paginate'
gem 'wicked' # Multistep registration form
gem 'gon'
gem 'settingslogic'

gem 'devise'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-vkontakte'
gem 'ancestry'
gem 'aasm'
gem 'pg'
gem 'breadcrumbs_on_rails'

gem 'active_model_serializers'
# gem 'torihiki', git: 'https://github.com/vforvova/simple_transaction'

# Assets

gem 'rails-assets-underscore'
gem 'rails-assets-bootstrap'
gem 'rails-assets-angular'
gem 'rails-assets-angular-bootstrap-checkbox'
gem 'rails-assets-angular-ui-router'
gem 'rails-assets-angular-i18n'
gem 'rails-assets-angular-ui-bootstrap-bower'
gem 'rails-assets-angular-animate'
gem 'rails-assets-jeremypeters--ng-bs-animated-button'
gem 'rails-assets-angular-wizard'
gem 'angular-rails-templates'
gem 'angularjs-rails-resource'

gem 'coffee-rails'
gem 'uglifier'
gem 'jquery-fileupload-rails'
gem 'compass-rails'
gem 'sass-rails'

gem 'puma'

# API
gem 'grape'
gem 'grape-entity'
gem 'grape_on_rails_routes'

group :development do
  gem 'pry-byebug'
end

if ENV['RAILS_ENV'] == 'production' #?!
  group :production do
    gem 'therubyracer'
  end
end

group :development, :test do
  gem 'annotate', require: false
  gem 'rspec-rails'
end

group :test do
  gem 'timecop'
  gem 'json_matchers'
  gem 'vcr'
  gem 'webmock'
  gem 'email_spec'
  gem 'database_cleaner'
  gem 'simplecov'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'guard-rspec'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'colorbox-rails', git: 'https://github.com/stevo/colorbox-rails.git'

gem 'xyeger'

gem 'daemons'
gem 'sidekiq'
#gem 'delayed_job_active_record'
