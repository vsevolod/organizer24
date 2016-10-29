# coding: utf-8
class NotificationsController < CompanyController
  before_action :redirect_if_not_owner

  def index
    @level = params[:level].to_i
    @from = params[:from].present? ? Date.parse(params[:from]) : Date.today.at_beginning_of_month
    @to = params[:to].present? ? Date.parse(params[:to]) : Date.today.at_end_of_month
    @from, @to = @to, @from if @to < @from
    case @level
    when 0
      @notifications = @organization.notifications
                                    .where(created_at: @from..@to)
                                    .group(:worker_id).select('worker_id, sum(cost) as total_cost, count(*) as count, count(length) as length')
    end
  end

  def sms
    @sms = @organization.sms_ru || @organization.build_sms_ru(phone: current_user.phone, sender: current_user.phone)
  end

  def send_sms
    @jobs = Delayed::Job.where('attempts > ?', 1)
    @jobs.update_all(run_at: Time.now)
    redirect_to :back, notice: "Сообщений на отправку: #{@jobs.count}"
  end

  def change_sms
    @sms = @organization.sms_ru || @organization.build_sms_ru
    if @sms.update_attributes(sms_ru_params)
      redirect_to action: :index, notice: 'Данные успешно изменены'
    else
      render :sms
    end
  end

  private

    def sms_ru_params
      params.require(:sms_ru).permit(:api_id, :sender, :phone, :translit)
    end
end
