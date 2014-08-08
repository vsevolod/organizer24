class PagesController < InheritedResources::Base
  include SetLayout
  layout :company

  belongs_to :organization
  has_scope :limit, :default => 8

  before_filter :find_organization
  before_filter :redirect_if_not_owner, :only => [:new, :edit, :create, :update, :destroy]

  def create
    create! { "/#{@page.permalink}" }
  end

  def update
    update! { "/#{@page.permalink}" }
  end

  protected

    def resource
      @page ||= @organization.pages.find_by_permalink( "/#{params[:id]}" )
    end

end
