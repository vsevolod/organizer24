class CategoryPhoto < ActiveRecord::Base
  has_ancestry 

  belongs_to :organization
  has_many :photos, dependent: :destroy
  attr_accessible :ancestry, :name, :parent_id, :ancestry, :photos_attributes

  validates :name, :presence => true

  accepts_nested_attributes_for :photos, allow_destroy: true

  # FIXME need to translate name?
  def to_param
    "#{self.id}-#{self.name}"
  end
end
