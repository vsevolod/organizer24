#coding: utf-8
class AppointmentsController < CompanyController
  before_filter :prepare_calendar_options, :only => :by_week
  before_filter :can_editable?, :only => [:change_start_time, :update, :change_status, :change_showing_time, :edit]
  before_filter :redirect_if_not_owner, :only => :phonebook

  respond_to :html, :json

  def show
    @appointment = Appointment.find( params[:id] )
    if @appointment.free?
      # Если зашли под создателем в только что созданную заявку - делаем её доступной и прикрепляем пользователя
      if current_user && @appointment.user_by_phone == current_user
        @appointment.user = current_user
        @appointment.first_owner_view
        @appointment.save
      else
        redirect_to root_path
      end
    elsif !@appointment.editable_by?(current_user || User.new)
      redirect_to root_path
    end
  end

  def edit
    @worker = @organization.workers.where(id: params[:worker_id]).first || @organization.workers.first
    @appointment = Appointment.find( params[:id] )
    respond_to do |format|
      format.js { render :inline => "$('.popover .popover-content').html('<%= escape_javascript(render 'form', appointment: @appointment, worker: @worker) %>')" }
    end
  end

  # FIXME вообще-то тут не по неделям. а по периодам. можно и переименовать.
  def by_week
    @prepare_periods = AppointmentsPresenters::ByWeekPresenter.new(current_user, @organization, params[:statuses], @start, @end, get_worker, @utc_offset)
    respond_with( @prepare_periods.render )
  end

  # GET список телефонных номеров и их владельцев
  # FIXME переместить наверно в контроллер workers?!
  def phonebook
    @phonebook = @organization.appointments.select("DISTINCT(phone), MAX(firstname) as firstname, MAX(lastname) as lastname").group("phone")
  end

  def create
    user_params = params[:user]
    @user = current_user || User.where( :phone => user_params[:phone] ).first_or_initialize( user_params )
    @appointment = @user.appointments.build( :start => Time.zone.at( params[:start].to_i/1000 ) - @utc_offset, :organization_id => @organization.id )
    @appointment.worker_id = get_worker.id
    @appointment.attributes = user_params
    if @appointment.firstname.blank? && @appointment.lastname.blank?
      @appointment.firstname = @user.firstname
      @appointment.lastname  = @user.lastname
    end
    @appointment.service_ids = (params[:service] || {}).keys
    check_notifier
    if @appointment.can_notify_owner?
      @appointment.showing_time = nil
    end
    @appointment.cost_time_by_services!
    if @user == current_user
      @appointment.first_owner_view
    else
      session[:phone] = params[:user][:phone]
    end
    respond_to do |format|
      if @appointment.save
        session[:appointment_new] = @appointment.id
        format.html{ redirect_to @appointment }
        format.js{ render :js => refresh_calendar }
      else
        format.html{ redirect_to :back, notice: "При сохранении возникла ошибка: #{@appointment.errors.full_messages.join('; ')}" }
        format.js{ render :js => "alert('Не добавлено: #{@appointment.errors.full_messages.join('; ')}');Organizer.removeOtherElements();" }
      end
    end
  end

  # TODO POST ajax query
  def change_status
    # Администратор может поменять статус заявки на любой. Клиент же только на "отменена"
    if current_user.owner_or_worker?( @organization ) || ( current_user == @appointment.user_by_phone && %w{cancel_client}.include?( params[:state] ) )
      @appointment.status = params[:state]
      if @appointment.save
        redirect_to "/calendar?day=#{@appointment.start.to_i+@utc_offset}", :notice => 'Статус успешно изменен'
      else
        redirect_to "/calendar?day=#{@appointment.start.to_i+@utc_offset}", :notice => 'При сохранении произошла ошибка'
      end
    else
      redirect_to :back, :alert => 'У вас не достаточно прав'
    end
  end

  # POST appointments/:id/change_start_time JS
  def change_start_time
    @appointment.start = Time.zone.at( params[:start].to_i/1000 ) - @utc_offset
    if @appointment.save
      render :text => <<-JS
        Organizer.draggable_item = null;
        Organizer.calendar_draggable = false;
        #{refresh_calendar}
      JS
    else
      render :text => 'alert("не верная дата")'
    end
  end

  # POST appointments/:id/change_showing_time JS
  def change_showing_time
    @appointment.showing_time = params[:showing_time]
    if @appointment.save
      render :text => refresh_calendar
    else
      render :text => 'alert("не верное время")'
    end
  end

  def update
    respond_to do |wants|
      if @appointment.update_attributes(params[:appointment])
        wants.html { redirect_to @appointment, notice:'Запись успешно изменена.' }
        wants.js   { render :js => refresh_calendar }
        wants.xml  { head :ok }
      else
        wants.html { render :action => "edit" }
        wants.js   { render :js => "alert('Не сохранено: #{@appointment.errors.full_messages.join('; ')}');" }
        wants.xml  { render :xml => @appointment.errors, :status => :unprocessable_entity }
      end
    end
  end

  private

    def refresh_calendar
      "Organizer.destroy_all_popovers();$('#calendar').fullCalendar('removeEvents').fullCalendar( 'refetchEvents' );"
    end

    def can_editable?
      @appointment = Appointment.find(params[:id])
      if current_user && @appointment.editable_by?(current_user)
        check_notifier
      else
        respond_to do |format|
          format.html { render :text => "У вас не хватает прав" }
          format.js   { render :text => "alert('Не хватает прав')"}
        end
      end
    end

    # Не уведомляем владельца если он сам и изменял запись
    def check_notifier
      if (@user || current_user).owner_or_worker?(@organization)
        @appointment.can_not_notify_owner = true
      end
    end

end
