class UsersController < CompanyController
  before_filter :authenticate_user!, :except => [:check_phone]

  def dashboard
    @user = current_user
  end

  def check_phone
    @user = User.find_by_phone(params[:phone])
    if @user
      render :text => "Exist"
    else
      render :text => "New Member"
    end
  end

end
