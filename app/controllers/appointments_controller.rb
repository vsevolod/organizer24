#coding: utf-8
class AppointmentsController < CompanyController
  before_filter :prepare_calendar_options, :only => :by_week
  before_filter :can_editable?, :only => [:change_start_time, :update, :change_status]

  respond_to :html, :json

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

  def edit
    @appointment = Appointment.find( params[:id] )
    respond_to do |format|
      format.js { render :inline => "$('#popover_for_change').html('<%= escape_javascript(render 'form', appointment: @appointment) %>')" }
    end
  end

  # FIXME вообще-то тут не по неделям. а по периодам. можно и переименовать.
  def by_week
    @is_owner = current_user.owner?( @organization )
    @appointments = if @is_owner
                      @organization.appointments.where( :status.in => params[:statuses] )
                    else
                      # Обычный пользователь просматривает только все что >= сегодняшнего дня
                      @organization.appointments.where( :status.in => %w{approve offer taken} ).where('date(start) >= ?', Date.today)
                    end.where('date(start) >= ? AND date(start) < ?', @start.to_date, @end.to_date)
    @periods = @appointments.map do |appointment|
      data_inner_class = if appointment.editable_by?( current_user )
                           'legend-your-offer'
                         else
                           "legend-#{appointment.status}"
                         end
      title = if ( @is_owner && ['taken', 'your-offer', 'offer', 'approve'].include?( appointment.status ) ) || ( !@is_owner && data_inner_class == 'legend-your-offer' )
                appointment.services.pluck('name').join('<br/>')
              else
                appointment.aasm_human_state
              end
      options = { :title => title,
                  :start => appointment.start.to_i,
                  :end => (appointment.start + appointment.showing_time.minutes).to_i,
                  :editable => false,
                  :is_owner => @is_owner,
                  'data-client' => (@is_owner ? "#{appointment.fullname} #{appointment.phone}" : "#{appointment.user.name} #{appointment.user.phone}"),
                  'data-inner-class' => data_inner_class,
                  'data-id' => appointment.id,
                  'data-services' => appointment.services_by_user.to_json(:only => [:name, :cost, :showing_time]) }
    end
    respond_with( @periods )
  end

  # GET список телефонных номеров и их владельцев
  def phonebook
    @phonebook = Appointment.select("DISTINCT(phone), MAX(firstname) as firstname, MAX(lastname) as lastname").group("phone")
  end

  def create
    @user = current_user || User.where( params[:user][:phone] ).first_or_initialize( params[:user] )
    @appointment = @user.appointments.build( :start => Time.parse( params[:start] ), :organization_id => @organization.id )
    @appointment.attributes = params[:user]
    @appointment.service_ids = params[:service].keys
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
        format.html{ redirect_to :back, notice: 'При сохранении возникла ошибка' }
        format.js{ render :js => "alert('Не добавлено: #{@appointment.errors.full_messages.join('; ')}');$('.cancel_calendar').trigger('click');" }
      end
    end
  end

  def change_status
    # Администратор может поменять статус заявки на любой. Клиент же только на "отменена"
    if current_user.owner?( @organization ) || ( current_user == @appointment.user && %w{cancel_client}.include?( params[:state] ) )
      @appointment.status = params[:state]
      if @appointment.save
        redirect_to "/calendar?date=#{@appointment.start.to_i}", :notice => 'Статус успешно изменен'
      else
        redirect_to "/calendar?date=#{@appointment.start.to_i}", :notice => 'При сохранении произошла ошибка'
      end
    else
      redirect_to :back, :alert => 'У вас не достаточно прав'
    end
  end

  # POST appointments/:id/change_start_time JS
  def change_start_time
    @appointment.start = params[:start]
    if @appointment.save
      render :text => <<-JS
        Organizer.draggable_item = null;
        Organizer.calendar_draggable = false;
        Organizer.destroy_popover_by_id( appointment_id );
      JS
    else
      render :text => 'alert("не верная дата")'
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
      unless @appointment.editable_by? current_user
        respond_to do |format|
          fornat.html { render :text => "У вас не хватает прав" }
          format.js   { render :text => "alert('Не хватает прав')"}
        end
      end
    end

end
