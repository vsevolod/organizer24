class Users::RegistrationsController < Devise::RegistrationsController
  include SetLayout
  before_action :find_organization
  layout :company

  def new
    @remote = params[:remote] == 'true'
    build_resource({})

    if defined?(@organization)
      resource.role = 'client'
      resource.current_step = 1
      resource.phone = params[:user][:phone] if (params[:user] || {})[:phone]
      render action: :edit, layout: !@remote && company
    else
      resource.role = 'admin'
      respond_with resource
    end
  end

  def create
    @appointment_id = params[:appointment_id]

    build_resource(user_params)

    resource.phone = PhoneService.parse(resource.phone)
    if resource.role == 'client'
      if resource.save
        appointment = Appointment.find_by(id: @appointment_id)
        if appointment && (!appointment.user || appointment.user == resource)
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
        render action: :edit, alert: 'При регистрации возникли ошибки'
      end
    else
      if resource.save
        redirect_to [:confirm_phone, resource]
      else
        render 'new'
      end
    end
  rescue PhoneService::NotValidPhone
    render 'new', alert: 'Телефон указан не верно. Укажите телефон в федеральном формате'
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :remember_me, :my_organization_attributes, :firstname, :lastname, :phone, :role)
  end
end
