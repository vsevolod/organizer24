#coding: utf-8
class AppointmentsController < CompanyController
  before_filter :prepare_calendar_options, :only => :by_week
  before_filter :can_editable?, :only => [:change_start_time, :update, :change_status, :change_showing_time, :edit]

  respond_to :html, :json

  def show
    @appointment = Appointment.find( params[:id] )
    @can_edit = current_user && ( @appointment.user_by_phone == current_user || current_user.owner?( @organization ) )
    if @appointment.free?
      # Если зашли под создателем в только что созданную заявку - делаем её доступной и прикрепляем пользователя
      if current_user && @appointment.user_by_phone == current_user
        @appointment.user = current_user
        @appointment.first_owner_view
        @appointment.save
      else
        redirect_to root_path
      end
    elsif !@can_edit
      redirect_to root_path
    end
  end

  def edit
    @appointment = Appointment.find( params[:id] )
    respond_to do |format|
      format.js { render :inline => "$('.popover .popover-content').html('<%= escape_javascript(render 'form', appointment: @appointment) %>')" }
    end
  end

  # FIXME вообще-то тут не по неделям. а по периодам. можно и переименовать.
  def by_week
    @user = current_user || User.new
    @worker = get_worker
    @is_owner = @user.owner?( @organization )
    @appointments = if @is_owner
                      @worker.appointments.where( :status.in => params[:statuses] )
                    else
                      # Обычный пользователь просматривает только все что >= сегодняшнего дня
                      @worker.appointments.where( :status.in => Appointment::STARTING_STATES ).where('date(start) >= ?', Time.zone.now.to_date)
                    end.where('date(start) >= ? AND date(start) < ?', @start.to_date, @end.to_date)
    # Находим записи
    @periods = @appointments.map do |appointment|
      editable = appointment.editable_by?( @user )
      data_inner_class = if editable
                           'legend-your-offer'
                         else
                           "legend-#{appointment.status}"
                         end
      title = if @is_owner && appointment.starting_state? || !@is_owner && editable
                appointment.services.pluck('name').join('<br/>')
              else
                appointment.aasm_human_state
              end
      options = { :title => title,
                  :start => appointment.start.to_i+@utc_offset,
                  :end => (appointment.start + appointment.showing_time.minutes).to_i+@utc_offset,
                  :editable => false,
                  :splitted => false,
                  :is_owner => @is_owner,
                  'data-inner-class' => data_inner_class,
                  'data-showing-time' => appointment.showing_time,
                  'data-id' => appointment.id,
                   }
      if editable
        options.merge!({ :splitted => true,
                         'data-client' => "#{appointment.fullname} #{appointment.phone}",
                         'data-id' => appointment.id,
                         'data-services' => appointment.services_by_user.to_json(:only => [:name, :cost, :showing_time])
        })
      end
      options
    end
    #Объединяем рядом стоящие чужие записи
    if !@is_owner
      @periods.each_with_index do |_this, index|
        if _this && !_this[:splitted] && ( _next = @periods.find{|p| p && p[:start] == _this[:end] && !p[:splitted]})
          _next[:start] = _this[:start]
          _next['data-showing-time'] += _this['data-showing-time']
          @periods[index] = nil
        end
      end
      @periods.compact!
    end
    respond_with( @periods )
  end

  # GET список телефонных номеров и их владельцев
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
    if current_user.owner?( @organization ) || ( current_user == @appointment.user && %w{cancel_client}.include?( params[:state] ) )
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
      if (@user || current_user).owner?(@organization)
        @appointment.can_not_notify_owner = true
      end
    end

end
