class Dictionary < ActiveRecord::Base
  has_ancestry

  belongs_to :organization
  validates :name, :uniqueness => { :scope => [:names_depth_cache, :organization_id] }, :presence => true
  validates :tag, :uniqueness => { :scope => [:organization_id] }, :if => Proc.new{|d| d.tag.presence}
  has_many :organizations, :foreign_key => :activity_id

  before_save :cache_ancestry
  def cache_ancestry
    self.names_depth_cache = path.map(&:name).join('/')
  end

  attr_accessible :name, :tag, :ancestry, :parent_id

end
