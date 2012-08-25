class AppointmentsController < ApplicationController

  def create
    # TODO что делать с пользователем - регестрировать его или нет?
    user = if signed_in?
             current_user
           else
             User.where( :phone => params[:phone] ).first
           end
    if user
      raise user.errors.inspect
      raise "STOP"
    end
    raise "SA"
  end

  def by_week
    @organization = Organization.find( params[:organization_id] )
    @start = Time.at( params[:start].to_i )
    @stop  = Time.at( params[:stop].to_i )
    @appointments = @organization.appointments.where( :start.gteq => @start )
  end

end
