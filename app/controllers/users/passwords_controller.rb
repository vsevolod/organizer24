class Users::PasswordsController < Devise::PasswordsController
  include SetLayout
  before_action :find_organization
  layout :company

  def create
    send_to_email = resource_params['phone'].blank?
    self.resource = if send_to_email
                      resource_class.send_reset_password_instructions(resource_params)
                    else
                      User.send_reset_password_instructions_by_phone(resource_params)
                end
    if resource.new_record? && !send_to_email
      resource.errors[:phone] = 'Пользователь с таким телефоном не найден'
    end

    if resource.new_record?
      respond_with(resource)
    else
      if send_to_email
        respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
      else
        @user = resource
        render action: 'confirm_phone'
      end
    end
  end
end
