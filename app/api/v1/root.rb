module API
  module V1
    class Root < Grape::API
      version 'v1'

      #include API::V1::Base
      include Entities

      mount API::V1::TelegramUsers
    end
  end
end
