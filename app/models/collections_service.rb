# == Schema Information
#
# Table name: collections_services
#
#  id            :integer          not null, primary key
#  service_id    :integer
#  collection_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CollectionsService < ApplicationRecord
  belongs_to :service
  belongs_to :collection, class_name: 'Service'
end
