class DoubleRate < ApplicationRecord
  # attr_accessible :begin_time, :day, :end_time, :week_day, :begin_hour, :begin_minute, :end_hour, :end_minute, :rate
  attr_accessor :begin_hour, :begin_minute, :end_hour, :end_minute

  default_scope ->{ order(:week_day, :day) }

  belongs_to :organization
  belongs_to :worker

  validates :week_day, presence: true, if: 'week_day.present?'
  validates :begin_time, presence: true
  validates :end_time, presence: true
  before_validation :fix_time
  before_save :set_organization

  def self.by_day(day, worker)
    where(worker_id: worker.id, day: day)
  end

  private

  def fix_time
    self.begin_time = (begin_hour.to_i * 60 + begin_minute.to_i) * 60
    self.end_time   = (end_hour.to_i * 60 + end_minute.to_i) * 60
  end

  def set_organization
    self.organization_id = worker.organization_id
  end
end
