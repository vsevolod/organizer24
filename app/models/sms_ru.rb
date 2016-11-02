class SmsRu < ApplicationRecord
  belongs_to :organization
  # attr_accessible :api_id, :sender, :phone, :translit
end
