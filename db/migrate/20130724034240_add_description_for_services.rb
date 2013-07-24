class AddDescriptionForServices < ActiveRecord::Migration
  def up
    add_column :services, :description, :text
  end

  def down
    remove_column :services, :description
  end
end
