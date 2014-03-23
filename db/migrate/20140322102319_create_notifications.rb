class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.references :user
      t.references :worker
      t.references :organization
      t.float :cost
      t.integer :length
      t.string :status
      t.string :type

      t.timestamps
    end
    add_index :notifications, :user_id
    add_index :notifications, :worker_id
    add_index :notifications, :organization_id
  end
end
