class CreateExecutors < ActiveRecord::Migration
  def change
    create_table :executors do |t|
      t.string :name
      t.string :phone
      t.references :organization

      t.timestamps
    end
    add_index :executors, :organization_id
  end
end
