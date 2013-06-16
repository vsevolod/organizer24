class ServicesUser < ActiveRecord::Base
  belongs_to :service
  belongs_to :user, :primary_key => :phone, :foreign_key => :phone
  belongs_to :organization
  # attr_accessible :title, :body
  
  validates :organization, :presence => true
  validates :service_id, :uniqueness => { :scope => [:organization_id, :phone] }

end
