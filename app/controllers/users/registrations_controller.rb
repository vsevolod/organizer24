class Users::RegistrationsController < Devise::RegistrationsController
  include SetLayout
  before_action :find_organization
  layout :company

  def new
    @resource = resource_class.new
    if defined?(@organization)
      @resource.role = 'client'
      @resource.current_step = 1
      @resource.phone = params[:user][:phone] if (params[:user] || {})[:phone]
      render action: :edit, layout: params[:remote] == 'true' ? false : company
    else
      @resource.role = 'admin'
      respond_with @resource
    end
  end

  def create
    @appointment_id = params[:appointment_id]
    @resource = resource_class.new(user_params)
    if @resource.role == 'client'
      if @resource.save
        if (appointment = Appointment.find_by(id: @appointment_id)) && (!appointment.user || appointment.user == @resource)
          appointment.user = @resource
          appointment.firstname = @resource.firstname
          appointment.save
        end
        if @resource.confirmed?
          sign_in @resource
          redirect_to '/calendar', notice: 'Вы успешно зарегистрированы'
        else
          redirect_to [:confirm_phone, @resource]
        end
      else
        render action: :edit, alert: 'При регистрации возникли ошибки'
      end
    else
      if @resource.save
        redirect_to [:confirm_phone, @resource]
      else
        render 'new'
      end
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :my_organization_attributes, :firstname, :lastname, :phone, :role)
  end
end
