class Address < ActiveRecord::Base
  belongs_to :user
  # attr_accessible :path, :phone
end
