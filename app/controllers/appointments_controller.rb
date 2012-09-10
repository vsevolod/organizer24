#coding: utf-8
class AppointmentsController < ApplicationController
  layout 'company'
  before_filter :find_organization, :only => [:show, :create, :by_week, :change_status]

  def show
    @appointment = Appointment.find( params[:id] )
    @can_edit = current_user && ( @appointment.user == current_user || current_user.owner?( @organization ) )
    if @appointment.free?
      if current_user
        if (@appointment.user_by_phone == current_user && @appointment.free?) || (@appointment.phone.blank? && session[:appointment_new] == params[:id].to_i)
          # Если зашли под создателем в только что созданную заявку - делаем её доступной и прикрепляем пользователя
          @appointment.user = current_user
          @appointment.first_owner_view
          @appointment.save
        end
      end
    end
  end

  def create
    @user = current_user || User.where( params[:user] ).first_or_initialize
    @appointment = @user.appointments.build( :start => Time.parse( params[:start] ), :organization_id => @organization.id )
    @appointment.phone = @user.phone
    @appointment.service_ids = params[:service].keys
    @appointment.cost_time_by_services!
    if @user == current_user
      @appointment.first_owner_view
    else
      session[:phone] = params[:user][:phone]
    end
    if @appointment.save
      session[:appointment_new] = @appointment.id
      redirect_to [@organization, @appointment]
    else
      redirect_to :back, notice: 'При сохранении возникла ошибка'
    end
  end

  def change_status
    @appointment = Appointment.find( params[:id] )
    if current_user.owner?( @organization ) || ( current_user == @appointment.user && %w{cancel_client}.include?( params[:state] ) )
      @appointment.status = params[:state]
      @appointment.save
      redirect_to [@organization, @appointment], :notice => 'Статус успешно изменен'
    else
      redirect_to :back, :alert => 'У вас не достаточно прав'
    end
  end

  def by_week
    @start = Time.at( params[:start].to_i )
    @stop  = Time.at( params[:stop].to_i )
    @appointments = @organization.appointments.where( :start.gteq => @start )
  end

end
