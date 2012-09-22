# coding: utf-8
class OrganizationsController < CompanyController
  skip_before_filter :find_organization, :only => [:index]

  def index
    @activities = Dictionary.find_by_tag('activity').try(:children)
  end

  def show
    @category_photos = @organization.category_photos.joins(:photos).uniq
  end

  def calendar
    if !current_user && @organization.registration_before?
      redirect_to organization_root, :alert => 'Для записи вам необходимо войти'
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
