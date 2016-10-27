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
    @organization = Organization.new(organization_params)
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
      if @organization.update_attributes( organization_params )
        redirect_to organization_root
      else
        render :edit
      end
    else
      raise @organization.owner.inspect
    end
  end

  private

    def organization_params
      params.require(:organization).permit([
        :name,
        :activity_id,
        :domain,
        :owner_id,
        :activity,
        { dictionaries_attributes: [
           :name,
           :tag,
           :ancestry,
           :parent_id,
           :children_dictionaries_attributes
          ],
          services_attributes: [
            :name,
            :showing_time,
            :cost,
            :is_collection,
            :show_by_owner,
            :bottom_cost,
            :top_cost,
            :description,
            :category_id,
            :position,
            :new_cost,
            :new_date_cost
          ],
          workers_attributes: [
            :name,
            :is_enabled,
            :services_workers_attributes,
            :phone,
            :user_id,
            :photo,
            :service_ids,
            :working_hours_attributes,
            :profession,
            :dative_case,
            :double_rates_attributes,
            :push_key,
            :finished_date,
            :sms_translit
          ]
        },
        *Organization::ACCESSORS
      ])
    end

end
