class CreateDoubleRates < ActiveRecord::Migration
  def change
    create_table :double_rates do |t|
      t.integer :week_day
      t.integer :begin_time
      t.integer :end_time
      t.references :organization
      t.references :worker
      t.date :day
      t.float :rate

      t.timestamps
    end
    add_index :double_rates, :organization_id
    add_index :double_rates, :worker_id
  end
end
