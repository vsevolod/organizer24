Warden::Strategies.add(:devise_strategy) do
  include UserService

  def valid?
    return false if request.get?
    user_data = params.fetch("user", {})
    !(user_data["phone"].blank? && user_data["email"].blank? || user_data["password"].blank?)
  end

  def authenticate!
    u = if params[:user_admin]
          UserAdmin.find_for_authentication(email: (params[:user_admin] || {})[:email])
        else
          User.find_for_authentication(phone: prepare_phone((params[:user] || {})[:phone]) )
        end
    if u.nil? || !u.valid_password?((params[:user] || params[:user_admin] || {})[:password])
      fail!('Пользователь или пароль не верен')
      redirect!('/users/sign_in')
    elsif u.methods.include?(:'confirmed?') && !u.confirmed?
      fail!('Вы должны подтвердить свой аккаунт.')
      redirect!("/users/#{u.id}/confirm_phone")
    else
      success!(u)
    end
  end
end
