class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.text :path
      t.string :phone
      t.references :user

      t.timestamps
    end
    add_index :addresses, :user_id
  end
end
