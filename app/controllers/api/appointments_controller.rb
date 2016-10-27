class Api::AppointmentsController < ApiController
  def index
    @appointments = @organization.appointments
    if params[:worker_id]
      @appointments = @appointments.where(worker_id: params[:worker_id])
    end
    if params[:date]
      @appointments = @appointments.where('date("appointments"."start") = ?', Time.parse(params[:date]).to_date)
    end
    render json: @appointments, each_serializer: EventSerializer
  end
end
