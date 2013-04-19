class CreateWorkers < ActiveRecord::Migration
  def change
    create_table :workers do |t|
      t.references :user
      t.references :organization
      t.string :name
      t.boolean :is_enabled

      t.timestamps
    end
    add_index :workers, :user_id
    add_index :workers, :organization_id
  end
end
