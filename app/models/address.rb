class Address < ApplicationRecord
  belongs_to :user
  # attr_accessible :path, :phone
end
