ENV['RAILS_ENV'] = 'test'

require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'sidekiq/testing'

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = Rails.root.join('spec', 'fixtures')
  config.use_transactional_fixtures = false
  config.alias_it_should_behave_like_to :with_shared_context, 'with shared context:'
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end
