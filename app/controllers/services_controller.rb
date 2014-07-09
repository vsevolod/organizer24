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

end
