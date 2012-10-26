class AddFioForAppointments < ActiveRecord::Migration
  def up
    add_column :appointments, :firstname, :string
    add_column :appointments, :lastname, :string
  end

  def down
    remove_column :appointments, :lastname
    remove_column :appointments, :firstname
  end
end
