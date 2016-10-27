# coding: utf-8
class CodesController < CompanyController
  before_action :redirect_if_not_owner
  add_breadcrumb 'На главную', '/'
  add_breadcrumb 'Сертификаты', Code, except: [:index]

  def index
    @codes = @organization.codes.order(:status)
  end

  def new
    @code = @organization.codes.build(params[:code])
    @workers = @organization.workers
  end

  def edit
    @code = @organization.codes.find(params[:id])
    @workers = @organization.workers
  end

  def create
    @code = @organization.codes.build(params[:code])
    @code.organization = current_user.my_organization || current_user.worker.try(:organization)
    if @code.save
      redirect_to Code
    else
      render 'new'
    end
  end

  def update
    @code = @organization.codes.find(params[:id])
    @code.attributes = params[:code]
    if @code.save
      redirect_to Code
    else
      render 'edit'
    end
  end

  def destroy
    @code = @organization.codes.find(params[:id])
    @code.destroy
    redirect_to Code
  end
end
