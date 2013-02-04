# coding: utf-8
class OrganizationsController < CompanyController
  skip_before_filter :find_organization, :only => [:index]
  add_breadcrumb 'На главную', '/', :except => [:index, :show]
  before_filter :redirect_if_not_owner, :only => [:edit, :update]

  def index
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def show
    redirect_to '/edit', alert: 'Заполните данные организации' if @organization.theme.blank?
    @category_photos = @organization.category_photos.joins(:photos).uniq
  end

  def calendar
    add_breadcrumb 'Календарь', '/calendar'
    if !current_user
      if @organization.registration_before?
        redirect_to organization_root, :alert => 'Для записи вам необходимо войти'
      else
        @current_user ||= User.new
      end
    else
      if current_user.owner?( @organization )
        @phonebook = Appointment.select("DISTINCT(phone), MAX(firstname) as firstname, MAX(lastname) as lastname").group("phone")
      end
    end
    if params[:day]
      @str_day = (Time.zone.at(params[:day].to_i) - 1.month).strftime("%Y, %m, %d")
    end
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
