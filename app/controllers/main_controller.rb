class MainController < ApplicationController
  def set_session
    # TODO: Тут должен быть список ключей которые можно переключать. Иначе нифига не секьюрно
    session[params[:key]] = params[:value]
    render plain: "Complete: #{params[:key]}"
  end
end
