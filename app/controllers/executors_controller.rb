class ExecutorsController < ApplicationController

  before_filter :find_organization
  before_filter :redirect_if_not_owner, :except => [:index]

  def index
    @executors = @organization.executors
  end

  def new
    @executor = @organization.executors.build
  end

  def edit
    @executor = @organization.executors.find(params[:id])
  end

  def create
    @executor = @organization.executors.build( params[:executor] )
    if @executor.save
      redirect_to [@organization, Executor]
    else
      render 'new'
    end
  end

  def update
    @executor = @organization.executors.find( params[:id] )
    if @executor.update_attributes( params[:executor] )
      redirect_to [@organization, Executor]
    else
      render 'edit'
    end
  end

  def destroy
    @executor = @organization.executors.find( params[:id] )
    @executor.destroy
    redirect_to [@organization, Executor]
  end


  private 

    def redirect_if_not_owner
      if !current_user.owner?( @organization )
        redirect_to [@organization, Executor]
      end
    end


end
