class ExecutorsController < CompanyController

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
      redirect_to Executor
    else
      render 'new'
    end
  end

  def update
    @executor = @organization.executors.find( params[:id] )
    if @executor.update_attributes( params[:executor] )
      redirect_to Executor
    else
      render 'edit'
    end
  end

  def destroy
    @executor = @organization.executors.find( params[:id] )
    @executor.destroy
    redirect_to Executor
  end

end
