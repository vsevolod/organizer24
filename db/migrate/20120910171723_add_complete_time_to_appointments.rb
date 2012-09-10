class AddCompleteTimeToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :complete_time, :datetime
  end
end
