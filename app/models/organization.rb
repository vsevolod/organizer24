class Organization < ActiveRecord::Base
  belongs_to :activity, :class_name => "Dictionary"
  belongs_to :owner, :class_name => "User"

end
