class CollectionsService < ApplicationRecord
  belongs_to :service
  belongs_to :collection, class_name: 'Service'
end
