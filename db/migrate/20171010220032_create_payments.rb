class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.datetime :date_till
      t.datetime :date_from
      t.integer :amount
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
