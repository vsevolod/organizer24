class UsersController < CompanyController
  before_filter :authenticate_user!

  def dashboard
    @user = current_user
  end

end
