class DictionarySerializer < ActiveModel::Serializer
  attributes :id, :name, :tag
  has_many :children
end
