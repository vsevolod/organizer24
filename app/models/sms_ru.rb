# == Schema Information
#
# Table name: sms_rus
#
#  id              :integer          not null, primary key
#  organization_id :integer
#  sender          :string(255)
#  api_id          :string(255)
#  phone           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  translit        :boolean          default(FALSE), not null
#  balance         :float
#

class SmsRu < ApplicationRecord
  belongs_to :organization
  # attr_accessible :api_id, :sender, :phone, :translit
end
