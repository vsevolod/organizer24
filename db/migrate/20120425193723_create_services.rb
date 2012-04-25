class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.integer :showing_time
      t.integer :cost
      t.references :organization

      t.timestamps
    end
    add_index :services, :organization_id
  end
end
