# coding: utf-8
class CategoryPhotosController < CompanyController
  before_action :redirect_if_not_owner, only: [:new, :edit, :create, :update, :destroy]
  before_action :find_ancestry_dictionaries, only: [:new, :edit, :create, :update]

  def index
    @category_photos = @organization.category_photos.includes(:photos).order(:name)
    if !current_user || !current_user.owner_or_worker?(@organization)
      redirect_to @category_photos.first if @category_photos.count == 1
    end
  end

  def new
    @category_photo = @organization.category_photos.build
  end

  def edit
    @category_photo = CategoryPhoto.find(params[:id])
  end

  def create
    @category_photo = @organization.category_photos.build(params[:category_photo])
    if @category_photo.save
      redirect_to @category_photo, notice: 'Категория успешно добавлена'
    else
      render action: 'new'
    end
  end

  def update
    @category_photo = CategoryPhoto.find(params[:id])
    if @category_photo.update_attributes(category_photo_params)
      redirect_to @category_photo, notice: 'Категория успешно изменена'
    else
      render action: 'edit'
    end
  end

  def show
    @category_photo = CategoryPhoto.find(params[:id])
    @photos = Photo.where(category_photo_id: @category_photo.children + [@category_photo])
  end

  def destroy
    @category_photo = CategoryPhoto.find(params[:id])
    @category_photo.destroy
    redirect_to action: 'index'
  end

  private

  def find_ancestry_dictionaries
    @ancestry_category_photos = ancestry_options((current_user.my_organization || current_user.worker.organization).category_photos.order('name')) { |i| "#{'-' * i.depth} #{i.name}" }
  end

  def category_photo_params
    params.require(:category_photo).permit([
                                             :ancestry,
                                             :name,
                                             :parent_id,
                                             :ancestry,
                                             photos_attributes: [:id, :_destroy, :name, :photo]
                                           ])
  end
end
