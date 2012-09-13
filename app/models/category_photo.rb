class CategoryPhoto < ActiveRecord::Base
  has_ancestry 

  belongs_to :organization
  attr_accessible :ancestry, :name, :parent_id, :ancestry

  # FIXME need to translate name?
  def to_param
    "#{self.id}-#{self.name}"
  end
end
