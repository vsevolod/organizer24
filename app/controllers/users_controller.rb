#coding: utf-8
class UsersController < CompanyController
  before_filter :authenticate_user!, :except => [:check_phone, :confirm_phone, :confirming_phone, :resend_confirmation_sms]

  def dashboard
    @user = current_user
  end

  def show
    @user = User.find_by_phone(params[:id]) || User.new(:phone => params[:id])
    redirect_to dashboard_path if current_user == @user || !current_user.owner_or_worker?(@organization)
    @appointments = @user.appointments_by_phone
  end

  def check_phone
    @user = User.find_by_phone(params[:phone])
    if @user
      render :text => "Exist"
    else
      render :text => "New Member"
    end
  end

  # TODO move to confirmation controller

  def resend_confirmation_sms
    @user = User.find(params[:id])
    if Time.zone.now > @user.updated_at + 1.minute
      @user.update_attribute(:updated_at, Time.zone.now)
      Delayed::Job.enqueue SmsJob.new( { :user_id => @user.id }, 'confirmation_number' ), :run_at => Time.zone.now
      redirect_to :back, :notice => 'На ваш телефон отправлено повторное смс с кодом подтверждения'
    else
      redirect_to :back, :alert => 'После последней отправки смс прошло меньше минуты'
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
      if @user.confirmation_number.to_s == params[:confirmation_number]
        @user.confirm!
        @user.appointments.free.each do |appointment|
          appointment.first_owner_view!
        end
        if @user.errors.any?
          flash[:alert] = @user.errors.full_messages.join('; ')
          render :action => :confirm_phone
        else
          sign_in @user
          redirect_to '/'
        end
      else
        redirect_to [:confirm_phone, @user], alert: 'Введен не верный код подтверждения'
      end
    end
  end

end
