# coding: utf-8
class CategoryPhotosController < CompanyController

  before_filter :redirect_if_not_owner, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :find_ancestry_dictionaries, :only => [:new, :edit, :create, :update]

  def index
    @category_photos = @organization.category_photos.order( :name )
    if !current_user || !current_user.owner?(@organization)
      if @category_photos.count == 1
        redirect_to @category_photos.first
      end
    end
  end

  def new
    @category_photo = @organization.category_photos.build
  end

  def edit
  end

  def create
    @category_photo = @organization.category_photos.build(params[:category_photo])
    if resource.save
      redirect_to resource, :notice => 'Категория успешно добавлено'
    else
      render :action => 'new'
    end
  end

  def update
    if resource.update_attributes( params[:category_photo] )
      redirect_to resource, :notice => 'Категория успешно изменена'
    else
      render :action => 'edit'
    end
  end

  def show
    @photos = Photo.where( :category_photo_id => resource.children.push(resource) )
  end

  def destroy
    resource.destroy
    redirect_to :action => 'index'
  end

  private

    def find_ancestry_dictionaries
      @ancestry_category_photos = ancestry_options(current_user.my_organization.category_photos.order( 'name')) {|i| "#{'-' * i.depth} #{i.name}" }
    end

    def resource
      @category_photo ||= if params[:id]
                            CategoryPhoto.find(params[:id])
                          else
                            CategoryPhoto.new( params[:category_photo] )
                          end
    end

    def redirect_if_not_owner
      super
      if !resource.new_record?
        if !current_user.owner?(resource.organization)
          redirect_to :action => :index, :error => 'У вас не достаточно прав'
        end
      end
    end

end
