class AddShowByOwnerToServices < ActiveRecord::Migration
  def change
    add_column :services, :show_by_owner, :boolean, null: false, default: false
  end
end
