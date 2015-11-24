class AddPushKeyForWorkers < ActiveRecord::Migration
  def up
    add_column :workers, :push_key, :string
  end

  def down
    remove_column :workers, :push_key
  end
end
