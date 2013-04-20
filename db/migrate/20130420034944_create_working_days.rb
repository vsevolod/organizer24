class CreateWorkingDays < ActiveRecord::Migration
  def change
    create_table :working_days do |t|
      t.date :date
      t.integer :begin_time
      t.integer :end_time
      t.references :worker

      t.timestamps
    end
    add_index :working_days, :worker_id
  end
end
