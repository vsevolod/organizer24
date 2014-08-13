class MainController < ApplicationController

  def set_session
    # TODO Тут должен быть список ключей которые можно переключать. Иначе нифига не секьюрно
    session[params[:key]] = params[:value]
    render :text => "complete: #{params[:key]}"
    #redirect_to :back
  end

end
