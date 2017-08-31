# == Schema Information
#
# Table name: working_days
#
#  id         :integer          not null, primary key
#  date       :date
#  begin_time :integer
#  end_time   :integer
#  worker_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class WorkingDay < ApplicationRecord
  belongs_to :worker
  # attr_accessible :begin_time, :date, :end_time
end
