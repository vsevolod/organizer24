class PhotosController < CompanyController
  before_filter :redirect_if_not_owner

  def create
    options = params[:photo]
    options.merge!({ :category_photo_id => params[:category_photo_id] })
    options[:photo] = options[:photo].first
    @photo = Photo.new( { :category_photo_id => params[:category_photo_id] } )
    @photo.attributes = options
    @photo.save
  end

  def destroy
    @photo = Photo.find( params[:id] )
    @photo.destroy
    redirect_to [:edit, @photo.category_photo]
  end

end
