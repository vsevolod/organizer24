# == Schema Information
#
# Table name: services
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  showing_time    :integer
#  cost            :integer
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  is_collection   :boolean
#  show_by_owner   :boolean          default(FALSE), not null
#  bottom_cost     :integer
#  top_cost        :integer
#  description     :text
#  category_id     :integer
#  position        :integer
#  new_cost        :integer
#  new_date_cost   :date
#

class ServiceSerializer < ActiveModel::Serializer
  attributes :id, :name, :cost, :showing_time, :show_by_owner, :description, :position, :new_cost, :new_date_cost

  has_one :category
  has_many :services
end
