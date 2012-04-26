class WorkingHour < ActiveRecord::Base
  belongs_to :organization

  validates :week_day, :presence => true
  validates :begin_time, :presence => true
  validates :end_time, :presence => true
  validates :organization, :presence => true

  attr_accessible :week_day, :begin_time, :end_time, :organization_id

end
