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
          res << { :title => 'закрыто', :start => (@start+index.days+min_wt).to_i, :end => (@start+index.days+wh.begin_time).to_i, :editable => false, 'data-inner-class' => 'legend-inaccessible' } if min_wt != wh.begin_time
          res << { :title => 'закрыто', :start => (@start+index.days+wh.end_time).to_i, :end => (@start+index.days+max_wt).to_i, :editable => false, 'data-inner-class' => 'legend-inaccessible' } if wh.end_time != max_wt
          @organization.appointments.where('date(start) = ?', (@start+index.days).to_date).where( :status.not_eq => 'free' ).each do |appointment|
            next unless ['approve', 'offer', 'taken'].include? appointment.status
            data_inner_class = if current_user == appointment.user
                                 if appointment.offer?
                                   'legend-your-offer'
                                 else
                                   'legend-inaccessible'
                                 end
                               else
                                 'legend-taken'
                               end
            res << { :title => appointment.aasm_human_state, :start => appointment.start.to_i, :end => (appointment.start + appointment.showing_time.minutes).to_i, :editable => false, 'data-inner-class' => data_inner_class, 'data-id' => appointment.id }
          end
          res
        else
          { :title => 'выходной', 'data-inner-class' => 'legend-inaccessible' }.merge( full_day )
        end
      else
        { :title => 'Запись невозможна', 'data-inner-class' => 'legend-old-day' }.merge( full_day )
      end
    end
    respond_with( @periods.flatten.compact )
  end

end
