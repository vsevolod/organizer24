class RemoveUserIdForWorkers < ActiveRecord::Migration
  def up
    remove_column :workers, :user_id
  end

  def down
    add_column :workers, :user_id, :integer
  end
end
