class RemoveAdminNotes < ActiveRecord::Migration
  def up
    drop_table :active_admin_comments
  end

  def down
    create_table :active_admin_comments do |t|
    end
  end
end
