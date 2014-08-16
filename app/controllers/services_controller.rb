# coding: utf-8
class ServicesController < CompanyController

  before_filter :redirect_if_not_owner

  def index
    @services = @organization.services
  end

  def new
    @service = @organization.services.build( params[:service] )
  end

  def edit
    @service = @organization.services.find(params[:id])
  end

  def create
    @service = @organization.services.build( params[:service] )
    if @service.save
      redirect_to Service
    else
      render 'new'
    end
  end

  def update
    @service = @organization.services.find( params[:id] )
    @service.attributes   = params[:service]
    if @service.save
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
    render text: 'complete'
  end

  def destroy
    @service = @organization.services.find( params[:id] )
    @service.destroy
    redirect_to Service
  end

  def statistic
    @worker = current_user.worker

    # Список услуг за последний год
    @appointments = @worker.appointments.where(:start.gteq => Time.now.at_beginning_of_year, :phone.not_eq => @worker.phone).where(status: %w{complete lated})
    gon.services_flot_dataset = {}
    12.times do |month|
      appointments = @appointments.where(:start.gteq => Time.now.at_beginning_of_year + month.month, :start.lt => Time.now.at_beginning_of_year + (month+1).month)
      services = Service.joins('INNER JOIN "appointments_services" ON "appointments_services".service_id = "services".id').where( appointments_services: {appointment_id: appointments.pluck(:id)}, show_by_owner: false).group('"services".id').select('"services".id, "services".name, count(*) as count, sum("services".cost) as cost')
      services.each do |service|
        gon.services_flot_dataset["service_#{service.id}"] ||= {label: service.name, data: []}
        gon.services_flot_dataset["service_#{service.id}"][:data].push([month, service.count, service.cost])
      end
    end

  end

end
