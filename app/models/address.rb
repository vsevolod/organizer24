# == Schema Information
#
# Table name: addresses
#
#  id         :integer          not null, primary key
#  path       :text
#  phone      :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Address < ApplicationRecord
  belongs_to :user
  # attr_accessible :path, :phone
end
