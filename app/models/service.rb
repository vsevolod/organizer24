class Service < ActiveRecord::Base
  belongs_to :organization
  has_and_belongs_to_many :appointments

  validates :name, :presence => true, :uniqueness => { :scope => [:organization_id] }
  validates :showing_time, :presence => true

end
