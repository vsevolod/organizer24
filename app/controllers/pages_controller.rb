class PagesController < InheritedResources::Base
  layout 'company'

  belongs_to :organization
  has_scope :limit, :default => 8

  before_filter :find_organization, :except => :index
  before_filter :redirect_if_not_owner, :only => [:new, :edit, :create, :update]

  def create
    create! { collection_url }
  end

end
