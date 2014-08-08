#coding: utf-8
class UsersController < CompanyController
  before_filter :authenticate_user!, :except => [:check_phone, :confirm_phone, :confirming_phone, :resend_confirmation_sms]
  before_filter :skip_when_confirmed, :only => [:confirming_phone, :confirm_phone]
  before_filter :redirect_if_not_owner, only: [:destroy]

  def dashboard
    @user = current_user
    @appointments = @user.appointments_by_phone.paginate(page: params[:page], per_page: 30)
  end

  def show
    @user = User.find_by_phone(params[:id]) || User.new(:phone => params[:id])
    redirect_to dashboard_path if current_user == @user || !current_user.owner_or_worker?(@organization)
    @appointments = @user.appointments_by_phone.paginate(page: params[:page], per_page: 30)
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
  end

  def confirming_phone
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
        if !Subdomain.matches?(request) && @user.is_admin?
          redirect_to '/organizations/new'
        else
          redirect_to '/'
        end
      end
    else
      redirect_to [:confirm_phone, @user], alert: 'Введен не верный код подтверждения'
    end
  end

  def update
    @user = User.find(params[:id])
    if current_user.owner_or_worker?(@organization) || current_user == @user
      @user.attributes = params[:user]
      if @user.save
        if @user.phone_changed? && !current_user.owner_or_worker?(@organization)
          @user.unconfirmed!
          redirect_to [:confirm_phone, @user], notice: 'Подтвердите свой телефон'
        else
          redirect_to :back, notice: 'Пользователь успешно изменен'
        end
      else
        redirect_to :back, error: 'При изменении произошли ошибки'
      end
    else
      redirect_to :back
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.appointments_by_phone.where(:status.not_in => %w{complete lated}).delete_all
    @user.appointments_by_phone.update_all(user_id: current_user.id)
    @user.destroy
    redirect_to '/calendar', notice: 'Пользователь успешно удален'
  end

  private

    def skip_when_confirmed
      @user = User.find(params[:id])
      if @user.confirmed?
        redirect_to '/'
      end
    end

end
