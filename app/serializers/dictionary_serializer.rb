# == Schema Information
#
# Table name: dictionaries
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  tag               :string(255)
#  ancestry          :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  names_depth_cache :string(255)
#  organization_id   :integer
#  dictionary_id     :integer
#

class DictionarySerializer < ActiveModel::Serializer
  attributes :id, :name, :tag
  has_many :children
end
