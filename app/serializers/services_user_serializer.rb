# == Schema Information
#
# Table name: services_users
#
#  id              :integer          not null, primary key
#  service_id      :integer
#  organization_id :integer
#  phone           :string(255)
#  cost            :integer
#  showing_time    :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class ServicesUserSerializer < ActiveModel::Serializer
  attributes :id, :service, :cost, :showing_time
  has_many :services
end
