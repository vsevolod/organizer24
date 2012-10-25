class MainController < ApplicationController

  def set_session
    session[params[:key]] = params[:value]
    #render :text => "complete: #{params[:key]}"
    redirect_to :back
  end

end
