class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.datetime :start
      t.integer :showing_time
      t.string :status
      t.references :user
      t.references :organization

      t.timestamps
    end
    add_index :appointments, :user_id
    add_index :appointments, :organization_id
  end
end
