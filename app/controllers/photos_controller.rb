class PhotosController < CompanyController
  before_filter :redirect_if_not_owner

  def create
    @photo = Photo.create( params[:photo].merge({ :category_photo_id => params[:category_photo_id] }) )
  end

  def destroy
    @photo = Photo.find( params[:id] )
    @photo.destroy
    redirect_to [:edit, @photo.category_photo]
  end

end
