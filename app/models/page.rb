class Page < ActiveRecord::Base
  belongs_to :organization
  # attr_accessible :content, :name, :permalink, :menu_name

  validates :content, :name, :permalink, presence: true
  validates :permalink, uniqueness: { scope: [:organization_id] }

  def to_param
    permalink
  end

  def show_page_link
    "/organizations/#{organization.id}/#{permalink}"
  end
end
