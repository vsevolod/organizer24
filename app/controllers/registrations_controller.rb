# coding: utf-8
class RegistrationsController < Devise::RegistrationsController
  include SetLayout
  before_filter :find_organization
  layout :company

  def new
    session[:user_params] ||= {}
    # очищать сессию на первом шаге
    #session[:user_params] = {}
    #session[:user_step] = nil
    resource = build_resource( session[:user_params] )
    if defined? @organization
      resource.role = 'client'
      resource.current_step = 1
      resource.phone = params[:user][:phone] if (params[:user] || {})[:phone]
      render :action => :edit, :layout => params[:remote] == 'true' ? false : company
    else
      resource.role = 'admin'
      resource.current_step = session[:user_step]
      respond_with resource
    end
  end

  def create
    @appointment_id = params[:appointment_id]
    (session[:user_params] || {}).deep_merge!( params[:user] ) if params[:user]
    build_resource( session[:user_params] )
    if resource.role == 'client'
      if resource.save
        if (appointment = Appointment.find_by_id( @appointment_id )) && (!appointment.user || appointment.user == resource)
          appointment.user = resource
          appointment.firstname = resource.firstname
          appointment.save
        end
        if resource.confirmed?
          sign_in resource
          redirect_to '/calendar', notice: 'Вы успешно зарегистрированы'
        else
          redirect_to [:confirm_phone, resource]
        end
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
          if resource.all_valid?
            resource.save
          end
        else
          resource.next_step
        end
        session[:user_step] = resource.current_step
      else
        if params[:back_button]
          resource.previous_step
        end
      end

      if resource.new_record?
        render "new"
      else
        session[:user_step] = session[:user_params] = nil
        redirect_to "http://#{resource.my_organization.domain}", :notice => 'Вы успешно зарегистрировались'
      end
    end
  end

end
