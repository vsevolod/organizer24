class AddProfessionToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :profession, :string
  end
end
