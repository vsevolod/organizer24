class PhotosController < CompanyController
  before_action :redirect_if_not_owner

  def create
    @photo = category_photo.photos.build
    @photo.attributes = photo_params
    @photo.save
  end

  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    redirect_to [:edit, @photo.category_photo]
  end

  private

  def category_photo
    CategoryPhoto.find(params[:category_photo_id])
  end

  def photo_params
    params.require(:photo).permit(:name, :photo)
  end
end
