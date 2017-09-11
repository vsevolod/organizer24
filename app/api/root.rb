module API
  class Root < Grape::API
    include API::Helpers::ErrorHandler

    prefix 'api/'

    format :json

    before do
      header['Access-Control-Allow-Origin'] = '*'
      header['Access-Control-Request-Method'] = '*'
    end

    mount API::V1::Root

    route :any, '*path' do
      error!({
        code: :not_found,
        message: "No such route '#{request.request_method} #{request.path}'"
      },
      404)
    end
  end
end
