# coding: utf-8
class RegistrationsController < Devise::RegistrationsController

  def new
    session[:user_params] ||= {}
    # очищать сессию на первом шаге
    #session[:user_params] = {}
    #session[:user_step] = nil
    resource = build_resource( session[:user_params] )
    resource.current_step = session[:user_step]
    respond_with resource
  end

  def create
    session[:user_params].deep_merge!( params[:user] ) if params[:user]
    build_resource( session[:user_params] )

    resource.build_my_organization unless resource.my_organization
    resource.current_step = session[:user_step]
    if resource.valid?
      if params[:back_button]
        resource.previous_step
      elsif resource.last_step?
        resource.save if resource.all_valid?
      else
        resource.next_step
      end
      session[:user_step] = resource.current_step
    end

    if resource.new_record?
      render "new"
    else
      session[:user_step] = session[:user_params] = nil
      redirect_to resource.organization, :notice => 'Вы успешно зарегистрировались'
    end
  end

end
