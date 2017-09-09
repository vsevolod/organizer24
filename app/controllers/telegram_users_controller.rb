class TelegramUsersController < CompanyController
  before_action :find_telegram_user

  def new; end

  def create
    if params[:confirmation_number] == @telegram_user.confirmation_number
      ConnectService.connect!(@telegram_user, current_user)
      redirect_to '/', notice: 'Вы успешно подтвердили Telegram аккаунт'
    else
      redirect_to :back, alert: 'Неверно введён номер для подтверждения'
    end
  end

  def show; end

  private

    def find_telegram_user
      @telegram_user = TelegramUser.confirmed.find_by(phone: current_user.phone)
      @telegram_user = TelegramUser.find_by(phone: current_user.phone)
      return if @telegram_user

      redirect_to :back, alert: 'В начале зарегистрируйтесь в телеграме'
    end
end
