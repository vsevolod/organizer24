class AddIndexToNotifications < ActiveRecord::Migration
  def change
    add_index :notifications, :appointment_id
  end
end
