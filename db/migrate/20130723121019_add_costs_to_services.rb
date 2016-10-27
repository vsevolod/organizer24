class AddCostsToServices < ActiveRecord::Migration
  def change
    add_column :services, :bottom_cost, :integer
    add_column :services, :top_cost, :integer
  end
end
