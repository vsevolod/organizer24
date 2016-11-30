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

# Use warden hook to setup current_user id in Cookie
Warden::Manager.after_set_user do |user,auth,opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = user.id
  auth.cookies.signed["#{scope}.expires_at"] = 30.minutes.from_now
end

# Cleanup once logged out
Warden::Manager.before_logout do |user, auth, opts|
  scope = opts[:scope]
  auth.cookies.signed["#{scope}.id"] = nil
  auth.cookies.signed["#{scope}.expires_at"] = nil
end
