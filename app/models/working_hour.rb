class WorkingHour < ActiveRecord::Base

  attr_accessor :begin_hour, :begin_minute, :end_hour, :end_minute

  default_scope order( :week_day )

  belongs_to :organization

  validates :week_day, :presence => true
  validates :begin_time, :presence => true
  validates :end_time, :presence => true
  before_validation :fix_time

  attr_accessible :week_day, :organization_id, :begin_hour, :begin_minute, :end_hour, :end_minute


  private

      def fix_time
        self.begin_time = (self.begin_hour.to_i*60+self.begin_minute.to_i)*60
        self.end_time   = (self.end_hour.to_i*60+self.end_minute.to_i)*60
      end

end
