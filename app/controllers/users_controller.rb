#coding: utf-8
class UsersController < CompanyController
  before_filter :authenticate_user!, :except => [:check_phone, :confirm_phone, :confirming_phone]

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

  def confirm_phone
    @user = User.find(params[:id])
    if @user.confirmed?
      redirect_to '/'
    end
  end

  def confirming_phone
    @user = User.find(params[:id])
    if @user.confirmed?
      redirect_to '/'
    else
      if @user.confirmation_number == params[:confirmation_number]
        @user.confirm!
      else
        redirect_to [:confirm_phone, @user], alert: 'Введен не верный код подтверждения'
      end
    end
  end

end
