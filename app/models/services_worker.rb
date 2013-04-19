class ServicesWorker < ActiveRecord::Base
  belongs_to :service
  belongs_to :worker
  attr_accessible :cost, :showing_time, :service_id
end
