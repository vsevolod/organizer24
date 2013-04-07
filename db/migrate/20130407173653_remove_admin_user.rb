class RemoveAdminUser < ActiveRecord::Migration
  def up
    drop_table :admin_users
  end

  def down
    create_table :admin_users do |t|
    end
  end
end
