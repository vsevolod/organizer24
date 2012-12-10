# coding:utf-8
class ServicesUsersController < CompanyController

  before_filter :find_appointment
  respond_to :html, :json

  def index
  end

  def update_services
    if @appointment.update_attributes( params[:appointment] )
      redirect_to [@appointment, :services_users], :notice => 'Изменения успешно применены'
    else
      render :action => :index, :alert => 'Во время изменения произошли ошибки'
    end
  end

  private

    def find_appointment
      @appointment = Appointment.find(params[:appointment_id])
      @user = @appointment.enshure_user
    end

end
