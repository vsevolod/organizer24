class Photo < ActiveRecord::Base
  belongs_to :category_photo
  attr_accessible :name, :photo
  has_attached_file :photo, :styles => { :medium => "300x300>",
                                         :thumb => "100x100>",
                                         :gallery => { :geometry => "800x600>",
                                                       :watermark_path => "#{Rails.root}/app/assets/images/watermark-depilate.png",
                                                       :position => "Center",
                                                       :processors => [:watermark]
                                                     }
                                       },
                            :convert_options => { :thumb => "-quality 75 -strip" }
end
