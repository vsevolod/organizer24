# coding: utf-8
class ServicesController < CompanyController
  before_action :redirect_if_not_owner

  def index
    @services = @organization.services
  end

  def new
    @service = @organization.services.build(service_params)
  end

  def edit
    @service = @organization.services.find(params[:id])
  end

  def create
    @service = @organization.services.build(service_params)
    if @service.save
      redirect_to Service
    else
      render 'new'
    end
  end

  def update
    @service = @organization.services.find(params[:id])
    if @service.update_attributes(service_params)
      redirect_to Service
    else
      render 'edit'
    end
  end

  # Сортируем сервисы
  def sort_services
    @organization.services.where(id: params[:service]).each do |service|
      service.update_column :position, params[:service].index(service.id.to_s)
    end
    render plain: 'complete'
  end

  def destroy
    @service = @organization.services.find(params[:id])
    @service.destroy
    redirect_to Service
  end

  def statistic
    @worker = current_user.worker

    # Список услуг за последний год
    @appointments = @worker.appointments.where(start: Time.now.at_beginning_of_year..Time.now.at_end_of_year, status: %w(complete lated)).where.not(phone: @worker.phone)
    gon.services_flot_dataset = {}
    12.times do |month|
      appointments = @appointments.where(start: (Time.now.at_beginning_of_year + month.month)...(Time.now.at_beginning_of_year + (month + 1).month))
      services = Service.joins('INNER JOIN "appointments_services" ON "appointments_services".service_id = "services".id').where(appointments_services: { appointment_id: appointments.pluck(:id) }, show_by_owner: false).group('"services".id').select('"services".id, "services".name, count(*) as count, sum("services".cost) as cost')
      services.each do |service|
        gon.services_flot_dataset["service_#{service.id}"] ||= { label: service.name, data: [] }
        gon.services_flot_dataset["service_#{service.id}"][:data].push([month, service.count, service.cost])
      end
    end
  end

  private

  def service_params
    params.require(:service).permit([
                                      :name,
                                      :showing_time,
                                      :cost,
                                      :is_collection,
                                      :show_by_owner,
                                      :bottom_cost,
                                      :top_cost,
                                      :description,
                                      :category_id,
                                      :position,
                                      :new_cost,
                                      :new_date_cost,
                                      {service_ids: []}
                                    ])
  rescue ActionController::ParameterMissing
    {}
  end
end
