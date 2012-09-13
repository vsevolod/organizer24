class CategoryPhotosController < InheritedResources::Base
  layout 'company'

  belongs_to :organization

  before_filter :find_organization
  before_filter :redirect_if_not_owner, :only => [:new, :edit, :create, :update, :destroy]
  before_filter :find_ancestry_dictionaries, :only => [:new, :edit]

  private

    def find_ancestry_dictionaries
      @ancestry_category_photos = ancestry_options(CategoryPhoto.order( 'name')) {|i| "#{'-' * i.depth} #{i.name}" }
    end

    def resource
      @category_photo = if params[:id]
                          CategoryPhoto.find(params[:id])
                        else
                          CategoryPhoto.new( params[:category_photo] )
                        end
    end

end
