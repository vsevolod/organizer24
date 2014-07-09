class AddPositionForServices < ActiveRecord::Migration
  def up
    add_column :services, :position, :integer
  end

  def down
    remove_column :services, :position
  end
end
