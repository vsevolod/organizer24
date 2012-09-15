class Photo < ActiveRecord::Base
  belongs_to :category_photo
  attr_accessible :name, :photo
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>", :gallery => "800x600>" }
end
