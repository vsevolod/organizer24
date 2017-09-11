module Helpers
  def self.spec_types
    @types ||= %i(controller enum job request)
  end

  def response_json
    JSON.parse(response.body)
  end
end

RSpec.configure do |config|
  Helpers.spec_types.each do |spec_type|
    config.include Helpers, type: spec_type
  end
end
