# coding: utf-8
class AddWorkerIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :worker_id, :integer
    Appointment.reset_column_information
    Organization.all.each do |organization|
      if organization.workers.count.zero?
        organization.workers.create(name: 'по умолчанию', is_enabled: true)
      end
      organization.appointments.update_all(worker_id: organization.workers.first.id)
    end
  end
end
