# coding: utf-8
class OrganizationsController < CompanyController
  skip_before_filter :find_organization, :only => [:index, :new, :create]
  add_breadcrumb 'На главную', '/', :except => [:index, :show]
  before_filter :redirect_if_not_owner, :only => [:edit, :update]
  before_filter :need_to_login, only: [:new, :create]

  def index
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def show
    @category_photos = @organization.category_photos.joins(:photos).uniq
  end

  def new
    @organization = Organization.new
    render layout: 'application'
  end

  def create
    @organization = Organization.new(params[:organization])
    @organization.owner = current_user
    if @organization.save
      session[:organization_id] = @organization.id
      redirect_to after_signup_index_path
    else
      render :new
    end
  end

  def modal
    render layout: false
  end

  def calendar
    add_breadcrumb 'Календарь', '/calendar'
    @presenter = OrganizationsPresenters::CalendarPresenter.new({ day: params[:day],
                                                                  worker_id: params[:worker_id],
                                                                  organization: @organization,
                                                                  current_user: current_user })
    if current_user
      gon.calendar = @presenter.calendar_settings
      gon.socket_options = {
        organization_id: @organization.id,
        user: current_user,
        worker_id: @presenter.worker.try(:id),
        isa: current_user.owner_or_worker?(@organization) # is admin?
      }
    end
    redirect_to organization_root, :alert => 'Для записи вам необходимо войти' if !signed_in? && @organization.registration_before?
  end

  def edit
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def update
    if current_user.owner?(@organization) || @organization.workers.map(&:user).include?(current_user)
      if @organization.update_attributes( params[:organization] )
        redirect_to organization_root
      else
        render :edit
      end
    else
      raise @organization.owner.inspect
    end
  end

end
