Warden::Strategies.add(:devise_strategy) do
  def authenticate! 
    u = User.find_for_authentication(:phone => (params[:user] || {})[:phone])
    if u.nil? || !u.valid_password?(params[:user][:password])
      fail(:invalid)
    elsif !u.confirmed?
      fail!("Account needs confirmation.")
      redirect!("/users/#{u.id}/confirm_phone")
    else
      success!(u)
    end    
  end
end
