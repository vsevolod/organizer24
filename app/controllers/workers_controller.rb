# coding: utf-8
class WorkersController < CompanyController

  before_filter :redirect_if_not_owner

  def index
    @workers = @organization.workers
  end

  def new
    @worker = @organization.workers.build( params[:worker] )
  end

  def edit
    @worker = @organization.workers.find(params[:id])
  end

  def services_workers
    @worker = @organization.workers.find(params[:id])
  end

  def create
    @worker = @organization.workers.build( params[:worker] )
    if @worker.save
      redirect_to Worker
    else
      render 'new'
    end
  end

  def update
    @worker = @organization.workers.find( params[:id] )
    if @worker.update_attributes(params[:worker])
      redirect_to Worker
    else
      render 'edit'
    end
  end

  def destroy
    @worker = @organization.workers.find( params[:id] )
    @worker.destroy
    redirect_to Worker
  end

end
