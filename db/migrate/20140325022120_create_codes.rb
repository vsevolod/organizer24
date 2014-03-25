class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string :number
      t.references :worker
      t.float :cost
      t.string :status
      t.references :user
      t.references :organization

      t.timestamps
    end
    add_index :codes, :worker_id
    add_index :codes, :user_id
  end
end
