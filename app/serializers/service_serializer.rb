class ServiceSerializer < ActiveModel::Serializer

  attributes :id, :name, :cost, :showing_time, :show_by_owner, :description, :position, :new_cost, :new_date_cost

  has_one :category
  has_many :services

end
