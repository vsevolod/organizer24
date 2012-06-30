# coding: utf-8
class WorkingHoursController < ApplicationController

  respond_to :html, :json

  before_filter :find_organization

  def by_week
    @start = Time.at( params[:start].to_i )
    min_wt = @organization.working_hours.pluck(:begin_time).min
    max_wt = @organization.working_hours.pluck(:end_time).max
    @periods = []
    [1,2,3,4,5,6,0].each_with_index do |t, index|
      full_day = {:start => (@start+index.days+min_wt).to_i, :end => (@start+index.days+max_wt).to_i, :editable => false}
      wh = @organization.working_hours.where(:week_day => t ).first
      @periods << if Date.today + @organization.last_day.to_i.days <= (@start + index.days).to_date
        if wh
          res = []
          res << { :title => 'закрыто', :start => (@start+index.days+min_wt).to_i, :end => (@start+index.days+wh.begin_time).to_i, :editable => false, :className => 'weekend' } if min_wt != wh.begin_time
          res << { :title => 'закрыто', :start => (@start+index.days+wh.end_time).to_i, :end => (@start+index.days+max_wt).to_i, :editable => false, :className => 'weekend' } if wh.end_time != max_wt
          res
        else
          { :title => 'выходной', :className => 'weekend' }.merge( full_day )
        end
      else
        { :title => 'Запись невозможна', :className => 'old_days' }.merge( full_day )
      end
    end
    respond_with( @periods.flatten.compact )
  end

end
