class WidgetsController < CompanyController
  skip_before_action :verify_authenticity_token

  respond_to :html, :js
  layout false

  def main
    if @organization.api_token == params[:token]
      @widget_id = params.fetch(:widget_id, 'widgetMain')
    else
      render js: 'console.log("Token doesn\'t compare with organization")'
    end
  end

  def show
    @template = params[:id]

    respond_with @template
  end
end
