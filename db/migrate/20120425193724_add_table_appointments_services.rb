class AddTableAppointmentsServices < ActiveRecord::Migration
  def up
    create_table :appointments_services, :id => false do |t|
      t.integer :appointment_id
      t.integer :service_id
    end
  end

  def down
    drop_table :appointments_services
  end
end
