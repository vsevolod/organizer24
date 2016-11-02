class Page < ApplicationRecord
  belongs_to :organization

  validates :content, :name, :permalink, presence: true
  validates :permalink, uniqueness: { scope: [:organization_id] }

  def to_param
    permalink
  end

  def show_page_link
    "/#{permalink}"
  end
end
