class AddWorkerIdToWorkingHours < ActiveRecord::Migration
  def change
    add_column :working_hours, :worker_id, :integer
    add_index :working_hours, :worker_id
  end
end
