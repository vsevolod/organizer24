class PagesController < CompanyController
  before_action :redirect_if_not_owner, only: [:new, :edit, :create, :update, :destroy]

  def index
    @pages = @organization.pages
  end

  def new
    @page = @organization.pages.build(page_params)
  end

  def show
    @page = @organization.pages.find_by_permalink(params[:id])
  end

  def edit
    @page = @organization.pages.find_by_permalink(params[:id])
  end

  def create
    @page = @organization.pages.build(page_params)
    if @page.save
      redirect_to Page
    else
      render 'new'
    end
  end

  def update
    @page = @organization.pages.find_by_permalink(params[:id])
    if @page.update_attributes(page_params)
      redirect_to Page
    else
      render 'edit'
    end
  end

  def destroy
    @page = @organization.pages.find_by_permalink(params[:id])
    @page.destroy
    redirect_to Page
  end

  protected

    def resource
      @page ||= @organization.pages.where(permalink: ["/#{params[:id]}", params[:id]]).first
    end

    def page_params
      params.fetch(:page, {}).permit([:content, :name, :permalink, :menu_name])
    end
end
