# == Schema Information
#
# Table name: services_workers
#
#  id           :integer          not null, primary key
#  service_id   :integer
#  worker_id    :integer
#  cost         :integer
#  showing_time :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  date_off     :date
#

class ServicesWorker < ApplicationRecord
  belongs_to :service
  belongs_to :worker
  # attr_accessible :cost, :showing_time, :service_id, :date_off

  scope :can_be_expired, -> { where('date_off IS NOT NULL AND date_off > date(?)', Time.now) }

  # handle_asynchronously :update_new_cost!, run_at: Proc.new{|sw| sw.new_date_cost}
end
