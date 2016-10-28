# coding: utf-8
class AppointmentsController < CompanyController
  before_action :prepare_calendar_options, only: :by_week
  before_action :can_editable?, only: [:update, :change_status, :change_params, :edit]
  before_action :redirect_if_not_owner, only: [:phonebook, :update_all]

  respond_to :html, :json

  def show
    @appointment = Appointment.find(params[:id])
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
    @appointment = Appointment.find(params[:id])
    respond_to do |format|
      format.js { render inline: "$('.popover .popover-content').html('<%= escape_javascript(render 'form', appointment: @appointment, worker: @worker) %>')" }
    end
  end

  # FIXME: вообще-то тут не по неделям. а по периодам. можно и переименовать.
  def by_week
    @prepare_periods = AppointmentsPresenters::ByWeekPresenter.new(current_user, @organization, params[:statuses], @start, @end, get_worker)
    respond_with(@prepare_periods.render)
  end

  # GET список телефонных номеров и их владельцев
  # FIXME переместить наверно в контроллер workers?!
  def phonebook
    @phonebook = @organization.appointments.select('DISTINCT(phone), MAX(firstname) as firstname, MAX(lastname) as lastname').group('phone')
  end

  def create
    @user = current_user || User.where(phone: user_params[:phone]).first_or_initialize(user_params)
    @appointment = @user.appointments.build(start: Time.parse(params[:start]) - Time.zone.utc_offset, organization_id: @organization.id)
    @appointment.worker_id = get_worker.id
    @appointment.attributes = user_params
    if @appointment.firstname.blank? && @appointment.lastname.blank?
      @appointment.firstname = @user.firstname
      @appointment.lastname  = @user.lastname
    end
    #################### проверка на minutes ## костыль про перевод времени
    if params[:minutes] && (params[:minutes].to_i - (@appointment.start - @appointment.start.at_beginning_of_day).to_i / 60).abs == 60
      @appointment.start = @appointment.start - 1.hour
    end
    ####################
    @appointment.service_ids = (params[:service] || {}).keys
    check_notifier
    @appointment.showing_time = nil if @appointment.can_notify_owner?
    @appointment.cost_time_by_services!
    if @user == current_user
      @appointment.first_owner_view
    else
      session[:phone] = params[:user][:phone]
    end
    respond_to do |format|
      if @appointment.save
        session[:appointment_new] = @appointment.id
        format.html { redirect_to @appointment }
        format.js do
          # yaCounter19193956.hit('/appointments#create', 'Добавление записи', null, {appointment_id: #{@appointment.id}});
          render js: <<-JS
            if (typeof(yaCounter19193956) != 'undefined'){
              yaCounter19193956.reachGoal('CreateAppointment', {order_id: #{@appointment.id}, price: #{@appointment.cost.to_f}, owner: #{!!@appointment.can_not_notify_owner}});
            };
            #{refresh_calendar}
          JS
        end
      else
        format.html { redirect_to :back, notice: "При сохранении возникла ошибка: #{@appointment.errors.full_messages.join('; ')}" }
        format.js { render js: "alert('Не добавлено: #{@appointment.errors.full_messages.join('; ')}');Organizer.removeOtherElements();" }
      end
    end
  end

  # TODO: POST ajax query
  def change_status
    # Администратор может поменять статус заявки на любой. Клиент же только на "отменена"
    if current_user.owner_or_worker?(@organization) || (current_user == @appointment.user_by_phone && %w(cancel_client).include?(params[:state]))
      @appointment.status = params[:state]
      respond_to do |wants|
        if @appointment.save
          wants.html { redirect_to "/calendar?day=#{@appointment.start.to_i}", notice: 'Статус успешно изменен' }
          wants.js   { render js: refresh_calendar }
        else
          wants.html { redirect_to "/calendar?day=#{@appointment.start.to_i}", notice: 'При сохранении произошла ошибка' }
          wants.js   { render js: "alert('при сохранении произошла ошибка'" }
        end
      end
    else
      redirect_to :back, alert: 'У вас не достаточно прав'
    end
  end

  # POST appointments/:id/change_params JS
  def change_params
    @appointment.showing_time = params[:showing_time].to_i if params[:showing_time]
    @appointment.cost = params[:cost] if params[:cost]
    @appointment.start = Time.parse(params[:start]) - Time.zone.utc_offset if params[:start]
    if @appointment.save
      render text: <<-JS
        Organizer.draggable_item = null;
        Organizer.calendar_draggable = false;
        #{refresh_calendar}
      JS
    else
      render text: "alert('Произошла ошибка: #{@appointment.errors.full_messages.join(', ')}');Organizer.removeOtherElements();"
    end
  end

  def update
    respond_to do |wants|
      if @appointment.update_attributes(appointment_params)
        wants.html { redirect_to @appointment, notice: 'Запись успешно изменена.' }
        wants.js   { render js: refresh_calendar }
        wants.xml  { head :ok }
      else
        wants.html { render action: 'edit' }
        wants.js   { render js: "alert('Не сохранено: #{@appointment.errors.full_messages.join('; ')}');" }
        wants.xml  { render xml: @appointment.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_all
    @appointments = @organization.appointments.where(phone: params[:old_phone])
    @appointments.update_all(phone: params[:phone], lastname: params[:lastname], firstname: params[:firstname])
    redirect_to users_path(id: params[:phone]), notice: 'Записи успешно изменены'
  end

  private

  def refresh_calendar
    <<-JS
        Organizer.destroy_all_popovers();
        $('#calendar').fullCalendar('removeEvents');
        $('#calendar').fullCalendar('refetchEvents');
      JS
  end

  def can_editable?
    @appointment = Appointment.find(params[:id])
    if current_user && @appointment.editable_by?(current_user)
      check_notifier
    else
      respond_to do |format|
        format.html { render text: 'У вас не хватает прав' }
        format.js   { render text: "alert('Не хватает прав')" }
      end
    end
  end

  # Не уведомляем владельца если он сам и изменял запись
  def check_notifier
    if (@user || current_user).owner_or_worker?(@organization)
      @appointment.can_not_notify_owner = true
    end
  end

  def appointment_params
    params.require(:appointment).permit([
                                          :start,
                                          :organization_id,
                                          :appointment_services,
                                          :showing_time,
                                          :service_ids,
                                          :phone,
                                          :firstname,
                                          :lastname,
                                          :worker_id,
                                          :comment,
                                          services_users_attributes: [:title, :body]
                                        ])
  end

  def user_params
    params.require(:user).permit(:phone, :firstname, :lastname, :showing_time, :comment)
  end
end
