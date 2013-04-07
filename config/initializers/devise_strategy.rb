Warden::Strategies.add(:devise_strategy) do
  def authenticate! 
    u = if params[:user_admin]
          UserAdmin.find_for_authentication(:email => (params[:user_admin] || {})[:email])
        else
          User.find_for_authentication(:phone => (params[:user] || {})[:phone])
        end
    if u.nil? || !u.valid_password?((params[:user] || params[:user_admin] || {})[:password])
      fail(:invalid)
    elsif u.methods.include?(:'confirmed?') && !u.confirmed?
      fail!("Account needs confirmation.")
      redirect!("/users/#{u.id}/confirm_phone")
    else
      success!(u)
    end    
  end
end
