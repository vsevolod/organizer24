class AddPhoneToWorkers < ActiveRecord::Migration
  def change
    add_column :workers, :phone, :string
  end
end
