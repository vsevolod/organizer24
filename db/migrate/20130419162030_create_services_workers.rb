class CreateServicesWorkers < ActiveRecord::Migration
  def change
    create_table :services_workers do |t|
      t.references :service
      t.references :worker
      t.integer :cost
      t.integer :showing_time

      t.timestamps
    end
    add_index :services_workers, :service_id
    add_index :services_workers, :worker_id
  end
end
