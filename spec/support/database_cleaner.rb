RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  # Order is important
  config.around clean_up: :truncate do |example|
    DatabaseCleaner.strategy = :truncation
    example.run # Execute cleaning
    DatabaseCleaner.strategy = :transaction
  end

  config.around do |example|
    DatabaseCleaner.cleaning { example.run }
  end
end
