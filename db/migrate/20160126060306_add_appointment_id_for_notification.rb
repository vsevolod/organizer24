class AddAppointmentIdForNotification < ActiveRecord::Migration
  def up
    add_column :notifications, :appointment_id, :integer, index: true
  end

  def down
    remove_column :notifications, :appointment_id
  end
end
