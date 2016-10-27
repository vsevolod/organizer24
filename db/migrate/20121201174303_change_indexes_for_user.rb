class ChangeIndexesForUser < ActiveRecord::Migration
  def up
    remove_index :users, ['email']
    add_index :users, ['phone']
  end

  def down
    remove_index :users, ['phone']
    add_index :users, ['email']
  end
end
