# coding: utf-8
class UsersController < CompanyController
  before_action :authenticate_user!, except: [:check_phone, :confirm_phone, :confirming_phone, :resend_confirmation_sms]
  before_action :skip_when_confirmed, only: [:confirming_phone, :confirm_phone]
  before_action :redirect_if_not_owner, only: [:destroy]

  def dashboard
    @user = current_user
    @appointments = @user.appointments_by_phone.where(organization_id: @organization.id).paginate(page: params[:page], per_page: 30)
  end

  def show
    @user = User.find_by(phone: params[:id]) || User.new(phone: params[:id])
    redirect_to dashboard_path if current_user == @user || !current_user.owner_or_worker?(@organization)
    @appointments = @user.appointments_by_phone.paginate(page: params[:page], per_page: 30)
  end

  def check_phone
    @user = User.find_by(phone: params[:phone])
    if @user
      render plain: 'Exist'
    else
      render plain: 'New Member'
    end
  end

  # TODO: move to confirmation controller
  def resend_confirmation_sms
    @user = User.find(params[:id])
    if Time.zone.now > @user.updated_at + 1.minute
      @user.update_attribute(:updated_at, Time.zone.now)
      SmsJob.perform_later({ user_id: @user.id }, 'confirmation_number')
      redirect_to :back, notice: 'На ваш телефон отправлено повторное смс с кодом подтверждения'
    else
      redirect_to :back, alert: 'После последней отправки смс прошло меньше минуты'
    end
  end

  def confirm_phone
  end

  def confirming_phone
    if @user.confirmation_number.to_s == params[:confirmation_number]
      @user.confirm!
      @user.appointments.free.each(&:first_owner_view!)
      if @user.errors.any?
        flash[:alert] = @user.errors.full_messages.join('; ')
        render action: :confirm_phone
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
      if @user.update(user_params)
        @organization.appointments.where(phone: current_user.phone).update_all(user_params)
        if @user.phone_changed? && current_user == @user
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
    @user.appointments_by_phone.where.not(status: %w(complete lated)).delete_all
    @user.appointments_by_phone.update_all(user_id: current_user.id)
    @user.destroy
    redirect_to '/calendar', notice: 'Пользователь успешно удален'
  end

  def statistic
    @worker = current_user.worker
    @appointments = @worker.appointments.where(start: Time.now.at_beginning_of_year..Time.now.at_end_of_year).where.not(phone: @worker.phone)

    # Группировка appointments по месяцам
    month_group = proc { |appointments| appointments.group_by { |a| a.start.month }.inject([]) { |result_arr, arr| result_arr.push([arr[0], arr[1].size, arr[1].map(&:cost).compact.sum]) }.sort_by(&:first) }

    # Количество всех записей по статусам по месяцам
    gon.appointments_flot_dataset = @appointments.group_by(&:status).to_a.each_with_object({}) do |el, hash|
      hash[el.first] = {
        label: I18n.t("activerecord.attributes.appointment.status.#{el.first}"),
        data: month_group.call(el.last)
      }
    end

    # Количество выполненных записей по пользователям (новым/старым)
    worker_phones = @worker.appointments.where(start: Time.at(0)...Time.now.at_beginning_of_year).where.not(phone: @worker.phone).pluck(:phone).uniq
    gon.users_flot_dataset = @appointments.where(status: %w(complete lated)).order(:start).group_by do |a|
      if worker_phones.include?(a.phone)
        true
      else
        worker_phones.push(a.phone)
        false
      end
    end.each_with_object({}) do |el, hash|
      hash[el.first.to_s] = {
        label: (el.first ? 'Пришедшие повторно' : 'Новые'),
        data: month_group.call(el.last)
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(:phone, :firstname, :lastname, :showing_time, :comment)
  end

  def skip_when_confirmed
    @user = User.find(params[:id])
    redirect_to '/' if @user.confirmed?
  end
end
