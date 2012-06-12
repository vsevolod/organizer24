class ServicesController < ApplicationController

  before_filter :find_organization
  before_filter :redirect_if_not_owner, :except => [:index]

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
      redirect_to [@organization, Service]
    else
      render 'new'
    end
  end

  def update
    @service = @organization.services.find( params[:id] )
    @service.attributes   = params[:service]
    if @service.save
      redirect_to [@organization, Service]
    else
      render 'edit'
    end
  end

  def destroy
    @service = @organization.services.find( params[:id] )
    @service.destroy
    redirect_to [@organization, Service]
  end


  private 

    def redirect_if_not_owner
      if !current_user.owner?( @organization )
        redirect_to [@organization, Service]
      end
    end


end
