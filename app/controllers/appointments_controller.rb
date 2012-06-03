class AppointmentsController < ApplicationController

  def by_week
    @organization = Organization.find( params[:organization_id] )
    @start = Time.at( params[:start].to_i )
    @stop  = Time.at( params[:stop].to_i )
    @appointments = @organization.appointments.where( :start.gteq => @start )
  end

end
