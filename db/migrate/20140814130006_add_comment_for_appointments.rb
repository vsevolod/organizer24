class AddCommentForAppointments < ActiveRecord::Migration
  def up
    add_column :appointments, :comment, :string
  end

  def down
    remove_column :appointments, :comment
  end
end
