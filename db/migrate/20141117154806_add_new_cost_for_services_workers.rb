class AddNewCostForServicesWorkers < ActiveRecord::Migration
  def up
    add_column :services, :new_cost,      :integer
    add_column :services, :new_date_cost, :date
  end

  def down
    remove_column :services, :new_date_cost
    remove_column :services, :new_cost
  end
end
