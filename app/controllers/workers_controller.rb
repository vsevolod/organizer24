class WorkersController < CompanyController
  before_action :redirect_if_not_owner

  def index
    @workers = @organization.workers
  end

  def new
    @worker = @organization.workers.build(worker_params)
  end

  def edit
    @worker = @organization.workers.find(params[:id])
  end

  def services_workers
    @worker = @organization.workers.find(params[:id])
  end

  def create
    @worker = @organization.workers.build(worker_params)
    if @worker.save
      redirect_to Worker
    else
      render 'new'
    end
  end

  def update
    @worker = @organization.workers.find(params[:id])
    if @worker.update_attributes(worker_params)
      redirect_to Worker
    else
      render 'edit'
    end
  end

  def destroy
    @worker = @organization.workers.find(params[:id])
    @worker.destroy
    redirect_to Worker
  end

  private

  def worker_params
    params.require(:worker).permit([
                                     :name,
                                     :is_enabled,
                                     :phone,
                                     :user_id,
                                     :photo,
                                     :service_ids,
                                     :profession,
                                     :dative_case,
                                     :push_key,
                                     :finished_date,
                                     :sms_translit,
                                     {
                                       service_ids: [],
                                       double_rates_attributes: [:id, :_destroy, :begin_time, :day, :end_time, :week_day, :begin_hour, :begin_minute, :end_hour, :end_minute, :rate],
                                       working_hours_attributes: [:id, :_destroy, :week_day, :organization_id, :begin_hour, :begin_minute, :end_hour, :end_minute, :worker_id],
                                       services_workers_attributes: [:id, :_destroy, :cost, :showing_time, :service_id, :date_off]
                                     }
                                   ])
  rescue ActionController::ParameterMissing
    {}
  end
end
