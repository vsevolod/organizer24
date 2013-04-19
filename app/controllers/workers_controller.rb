# coding: utf-8
class WorkersController < CompanyController

  before_filter :redirect_if_not_owner, :except => [:index]

  def index
    @workers = @organization.workers
  end

  def new
    @worker = @organization.workers.build( params[:worker] )
  end

  def edit
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
    @worker.attributes = params[:worker]
    if @worker.save
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


  private 

    def redirect_if_not_owner
      if !current_user.owner?( @organization )
        redirect_to Worker
      end
    end

end
