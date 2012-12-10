class ServicesUser < ActiveRecord::Base
  belongs_to :service
  belongs_to :user
  belongs_to :organization
  # attr_accessible :title, :body
  
  validates :organization, :presence => true
  validates :service_id, :uniqueness => { :with => [:organization_id, :phone] }

end
