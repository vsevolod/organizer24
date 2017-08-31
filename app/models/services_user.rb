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

class ServicesUser < ApplicationRecord
  belongs_to :service
  belongs_to :user, primary_key: :phone, foreign_key: :phone
  belongs_to :organization
  # attr_accessible :title, :body

  validates :organization, presence: true
  validates :service_id, uniqueness: { scope: [:organization_id, :phone] }
end
