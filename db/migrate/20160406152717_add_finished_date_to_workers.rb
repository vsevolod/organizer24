class AddFinishedDateToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :finished_date, :date
  end
end
