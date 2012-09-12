class Page < ActiveRecord::Base
  belongs_to :organization
  attr_accessible :content, :name, :permalink

  validates_presence_of :content, :name, :permalink
  validates :permalink, :uniqueness => { :scope => [:organization_id] }

end
