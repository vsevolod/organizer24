class CreateTelegramUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :telegram_users do |t|
      t.integer :telegram_id, null: false
      t.string :username, null: false
      t.string :confirmation_number
      t.boolean :confirmed, null: false, default: false

      t.jsonb :data
      t.string :phone

      t.timestamps
    end
  end
end
