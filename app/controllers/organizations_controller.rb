# coding: utf-8
class OrganizationsController < CompanyController
  skip_before_filter :find_organization, :only => [:index]
  add_breadcrumb 'На главную', '/', :except => [:index, :show]
  before_filter :redirect_if_not_owner, :only => [:edit, :update]

  def index
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def show
    @category_photos = @organization.category_photos.joins(:photos).uniq
  end

  def calendar
    add_breadcrumb 'Календарь', '/calendar'
    @presenter = OrganizationsPresenters::CalendarPresenter.new({ day: params[:day],
                                                                  worker_id: params[:worker_id],
                                                                  organization: @organization,
                                                                  current_user: current_user })
    redirect_to organization_root, :alert => 'Для записи вам необходимо войти' if !signed_in? && @organization.registration_before?
  end

  def edit
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def update
    if current_user.owner?( @organization)
      if @organization.update_attributes( params[:organization] )
        redirect_to organization_root
      else
        render :edit
      end
    end
  end

end
