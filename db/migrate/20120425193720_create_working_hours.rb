class CreateWorkingHours < ActiveRecord::Migration
  def change
    create_table :working_hours do |t|
      t.integer :week_day
      t.integer :begin_time
      t.integer :end_time
      t.references :organization

      t.timestamps
    end
    add_index :working_hours, :organization_id
  end
end
