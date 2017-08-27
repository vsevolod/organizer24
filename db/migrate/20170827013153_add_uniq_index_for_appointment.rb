class AddUniqIndexForAppointment < ActiveRecord::Migration[5.0]
  def change
    attrs_batch = Appointment.where.not(status: ['free', 'cancel_client', 'cancel_owner'])
      .group(:start, :showing_time, :status, :worker_id, :organization_id).count
      .find_all{|x, y| y > 1}

    attrs_batch.each do |attrs, count|
      (count - 1).times do
        Appointment.where.not(status: ['free', 'cancel_client', 'cancel_owner'])
          .where(start: attrs[0], showing_time: attrs[1], status: attrs[2], worker_id: attrs[3], organization_id: attrs[4])
          .take.destroy
      end
    end

    add_index :appointments,
      [:start, :showing_time, :status, :worker_id, :organization_id],
      where: "status NOT IN ('free', 'cancel_client', 'cancel_owner')",
      name: 'lock_duplicates',
      unique: true
  end
end
