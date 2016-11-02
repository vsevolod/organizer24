class WorkingDay < ApplicationRecord
  belongs_to :worker
  # attr_accessible :begin_time, :date, :end_time
end
