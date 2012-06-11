# coding: utf-8
class WorkingHoursController < ApplicationController

  respond_to :html, :json

  before_filter :find_organization

  def by_week
    @start = Time.at( params[:start].to_i )
    @periods = (0..6).to_a.map do |t|
                 wh = @organization.working_hours.where(:week_day => t).first
                 if wh
                   [ { :title => 'закрыто', :start => (@start+t.days).to_i, :stop => (@start+t.days+wh.begin_time).to_i, :editable => false, :className => 'weekend' },
                     { :title => 'закрыто', :start => (@start+t.days+wh.end_time).to_i, :stop => (@start+(t+1).days).to_i, :editable => false, :className => 'weekend' }]
                 else
                   { :title => 'выходной', :start => (@start+t.days).to_i, :stop => (@start+(t+1).days - 1).to_i, :editable => false, :className => 'weekend' }
                 end
               end.flatten.compact
    respond_with( @periods )
  end

end
