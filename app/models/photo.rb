class Photo < ActiveRecord::Base
  belongs_to :category_photo
  attr_accessible :name, :photo, :category_photo_id
  has_attached_file :photo, :styles => { :medium => "300x300>",
                                         :thumb => "100x100>",
                                         :gallery => { :geometry => "800x600>",
                                                       :watermark_path => Proc.new{|p| "#{Rails.root}/app/assets/images/watermark-#{p.instance.organization.domain}.png"},
                                                       :position => "Center",
                                                       :processors => [:watermark]
                                                     }
                                       },
                            :convert_options => { :thumb => "-quality 75 -strip" }

  delegate :organization, to:  :category_photo, allow_nil: false

end
