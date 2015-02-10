class WorkerSerializer < ActiveModel::Serializer

  attributes :id, :name, :phone, :photo
  has_many :services

  def photo
    object.photo.url(:normal)
  end

end
