class AppointmentsController < ApplicationController

  def create
    @organization = Organization.find( params[:organization_id] )
    @user = User.where( params[:user] ).first_or_initialize
    @appointment = @user.appointments.build( :start => Time.parse( params[:start] ), :organization_id => @organization.id )
    @appointment.service_ids = params[:service].keys
    @appointment.cost, @appointment.showing_time = @organization.cost_time_by_services
    raise @appointment.inspect
    raise "SA"
  end

  def by_week
    @organization = Organization.find( params[:organization_id] )
    @start = Time.at( params[:start].to_i )
    @stop  = Time.at( params[:stop].to_i )
    @appointments = @organization.appointments.where( :start.gteq => @start )
  end

end
