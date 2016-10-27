class ServicesUserSerializer < ActiveModel::Serializer
  attributes :id, :service, :cost, :showing_time
  has_many :services
end
