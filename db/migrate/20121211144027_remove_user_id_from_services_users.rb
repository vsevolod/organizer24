class RemoveUserIdFromServicesUsers < ActiveRecord::Migration
  def up
    remove_index :services_users, :user_id
    remove_column :services_users, :user_id
  end

  def down
    add_column :services_users, :user_id, :integer
    add_index :services_users, :user_id
  end
end
