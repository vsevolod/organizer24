class Photo < ActiveRecord::Base
  belongs_to :category_photo
  #attr_accessible :name, :photo, :category_photo_id
  has_attached_file :photo, :styles => { :medium => "300x300>",
                                         :thumb => "100x100>",
                                         :gallery => { :geometry => "800x600>",
                                                       :watermark_path => Proc.new{|p| "#{Rails.root}/app/assets/images/watermark-#{p.instance.organization.domain}.png"},
                                                       :position => "Center",
                                                       :processors => [:watermark]
                                                     },
                                         :carousel_gallery => "640x360#",
                                       },
                            :convert_options => { :thumb => "-quality 75 -strip" }

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]
  delegate :organization, to:  :category_photo, allow_nil: false

end
