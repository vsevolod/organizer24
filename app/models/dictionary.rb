class Dictionary < ActiveRecord::Base
  has_ancestry

  belongs_to :organization
  validates :name, :uniqueness => { :scope => [:names_depth_cache, :organization_id] }, :presence => true
  validates :tag, :uniqueness => { :scope => [:organization_id] }, :if => Proc.new{|d| d.tag.presence}
  has_many :organizations, :foreign_key => :activity_id

  has_many :children_dictionaries, class_name: 'Dictionary', foreign_key: :dictionary_id
  accepts_nested_attributes_for :children_dictionaries
  before_save :cache_ancestry
  before_save :set_dictionary_id

  #attr_accessible :name, :tag, :ancestry, :parent_id, :children_dictionaries_attributes

  def cache_ancestry
    self.names_depth_cache = path.map(&:name).join('/')
  end

  def set_dictionary_id
    if self.dictionary_id_changed?
      self.parent_id = self.dictionary_id
    elsif self.parent_id
      self.dictionary_id = self.parent_id
    end
  end

end
