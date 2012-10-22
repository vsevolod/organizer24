# coding: utf-8
class RegistrationsController < Devise::RegistrationsController
  include SetLayout
  before_filter :find_organization
  layout :company

  # Тут регаются только админы
  def new
    session[:user_params] ||= {}
    # очищать сессию на первом шаге
    #session[:user_params] = {}
    #session[:user_step] = nil
    resource = build_resource( session[:user_params] )
    if defined? @organization
      resource.role = 'client'
      resource.current_step = 1
      render :action => :edit
    else
      resource.role = 'admin'
      resource.current_step = session[:user_step]
      respond_with resource
    end
  end

  def create
    (session[:user_params] || {}).deep_merge!( params[:user] ) if params[:user]
    build_resource( session[:user_params] )

    if resource.role == 'client'
      if resource.save
        sign_in resource
        redirect_to '/', notice: 'Вы успешно зарегистрированы'
      else
        render :action => :edit, alert: 'При регистрации возникли ошибки'
      end
    else
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
        redirect_to calendar_url(subdomain: org.subdomain), :notice => 'Вы успешно зарегистрировались'
      end
    end
  end

end
