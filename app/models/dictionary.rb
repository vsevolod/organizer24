class Dictionary < ActiveRecord::Base
  has_ancestry

  validates :name, :uniqueness => { :scope => [:names_depth_cache] }, :presence => true

  before_save :cache_ancestry
  def cache_ancestry
    self.names_depth_cache = path.map(&:name).join('/')
  end

  attr_accessible :name, :tag, :ancestry, :parent_id

end
