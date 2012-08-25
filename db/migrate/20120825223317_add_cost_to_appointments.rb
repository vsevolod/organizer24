class AddCostToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :cost, :integer
  end
end
