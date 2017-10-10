module Errors
  extend ActiveSupport::Concern

  class ServiceUnavailableError < StandardError; end

  included do
    rescue_from ServiceUnavailableError do
      respond_to do |format|
        format.html { render file: Rails.root.join('public', '503'), layout: false, status: :service_unavailable }
        format.any { head :service_unavailable }
      end
    end
  end
end
