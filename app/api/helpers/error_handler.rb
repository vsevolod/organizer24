module API
  module Helpers
    module ErrorHandler
      extend ActiveSupport::Concern

      included do
        rescue_from Grape::Exceptions::ValidationErrors do |e|
          error_response status: 422, message: {
            code: :invalid,
            errors: Helpers.detailed_grape_errors(e)
          }
        end

        rescue_from :all do |e|
          Rails.logger.error e.message

          error_response status: 500, message: {
            code: :server_fault,
            message: 'Server failed to process your request.'
          }
        end
      end
    end
  end
end
