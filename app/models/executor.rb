class Executor < ActiveRecord::Base
  belongs_to :organization

  validates :name, :presence => true
  validates :phone, :presence => true, :uniqueness => true, :format => { :with => /^[\d\W]+$/ }

  attr_accessible :name, :phone, :organization_id

end
