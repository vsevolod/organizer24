class DoubleRate < ActiveRecord::Base
  #attr_accessible :begin_time, :day, :end_time, :week_day, :begin_hour, :begin_minute, :end_hour, :end_minute, :rate
  attr_accessor :begin_hour, :begin_minute, :end_hour, :end_minute

  default_scope order( :week_day, :day )

  belongs_to :organization
  belongs_to :worker

  validates :week_day, presence: true, if: 'week_day.present?'
  validates :begin_time, presence: true
  validates :end_time, presence: true
  before_validation :fix_time
  before_save :set_organization

  def self.by_day(day, worker)
    self.where(worker_id: worker.id, day: day)
  end

  private

      def fix_time
        self.begin_time = (self.begin_hour.to_i*60+self.begin_minute.to_i)*60
        self.end_time   = (self.end_hour.to_i*60+self.end_minute.to_i)*60
      end

      def set_organization
        self.organization_id = self.worker.organization_id
      end

end
