class Payment < ApplicationRecord
  belongs_to :organization

  scope :active, -> { where('? BETWEEN date_from AND date_till', Time.current) }
end
