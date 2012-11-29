class AddConfirmationNumberForUsers < ActiveRecord::Migration
  def up
    add_column :users, :confirmation_number, :integer
  end

  def down
    remove_column :users, :confirmation_number
  end
end
