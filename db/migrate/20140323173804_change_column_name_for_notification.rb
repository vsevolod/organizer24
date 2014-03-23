class ChangeColumnNameForNotification < ActiveRecord::Migration
  def up
    rename_column :notifications, :type, :notification_type
  end

  def down
    rename_column :notifications, :notification_type, :type
  end
end
