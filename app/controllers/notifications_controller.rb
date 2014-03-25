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

end
