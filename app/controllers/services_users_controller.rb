# coding:utf-8
class ServicesUsersController < CompanyController
  before_action :redirect_if_not_owner
  before_action :find_appointment
  respond_to :html, :json

  def index
  end

  def update_services
    if @appointment.update_attributes(appointment_params)
      @user.recount_appointments_by_organization_for_services_users!(@organization)
      redirect_to [@appointment, :services_users], notice: 'Изменения успешно применены'
    else
      render action: :index, alert: 'Во время изменения произошли ошибки'
    end
  end

  private

  def find_appointment
    @appointment = Appointment.find(params[:appointment_id])
    @user = @appointment.enshure_user
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
end
