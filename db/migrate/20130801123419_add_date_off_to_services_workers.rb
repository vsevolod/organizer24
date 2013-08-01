class AddDateOffToServicesWorkers < ActiveRecord::Migration
  def change
    add_column :services_workers, :date_off, :date
  end
end
