#coding: utf-8
class NotificationsController < CompanyController
  before_filter :redirect_if_not_owner

  def index
    @level = params[:level].to_i
    @from = params[:from] || Date.today.at_beginning_of_month
    @to = params[:to] || Date.today.at_end_of_month
    case @level
    when 0
      @notifications = @organization.notifications
        .where{created_at >= my{@from}}
        .where{created_at <= my{@to}}
        .group(:worker_id).select('worker_id, sum(cost) as total_cost, count(*) as count, count(length) as length')
    end
  end

  def sms
    @sms = @organization.sms_ru || @organization.build_sms_ru(phone: current_user.phone, sender: current_user.phone)
  end

  def change_sms
    @sms = @organization.sms_ru || @organization.build_sms_ru
    @sms.attributes = params[:sms_ru]
    if @sms.save
      redirect_to action: :index, notice: 'Данные успешно изменены'
    else
      render :sms
    end
  end

end
