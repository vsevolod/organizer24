# == Schema Information
#
# Table name: photos
#
#  id                 :integer          not null, primary key
#  name               :string(255)
#  category_photo_id  :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  photo_file_name    :string(255)
#  photo_content_type :string(255)
#  photo_file_size    :integer
#  photo_updated_at   :datetime
#

class Photo < ApplicationRecord
  belongs_to :category_photo

  has_attached_file :photo,
    styles: {
      medium: '300x300>',
      medium_cut: '300x300#',
      photo_slider: '760x400>',
      thumb: '100x100>',
      gallery: {
        geometry: '800x600>',
        watermark_path: Proc.new { |p|
          Rails.root.join("/app/assets/images/watermark-#{p.instance.organization.domain}.png")
        },
        position: 'Center',
        processors: [:watermark]
      },
      carousel_gallery: '640x360#'
    },
    convert_options: { thumb: '-quality 75 -strip' }

  validates_attachment_content_type :photo, content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']
  delegate :organization, to: :category_photo, allow_nil: false
end
