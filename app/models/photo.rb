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
