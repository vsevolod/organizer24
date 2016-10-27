class SmsRu < ActiveRecord::Base
  belongs_to :organization
  # attr_accessible :api_id, :sender, :phone, :translit
end
