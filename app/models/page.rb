class Page < ActiveRecord::Base
  belongs_to :organization
  #attr_accessible :content, :name, :permalink, :menu_name

  validates_presence_of :content, :name, :permalink
  validates :permalink, :uniqueness => { :scope => [:organization_id] }

  def to_param
    permalink
  end

  def show_page_link
    "/organizations/#{self.organization.id}/#{self.permalink}"
  end

end
