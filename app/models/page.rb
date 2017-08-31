# == Schema Information
#
# Table name: pages
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  permalink       :string(255)
#  content         :text
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  menu_name       :string(255)
#

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
