class CreateSmsRus < ActiveRecord::Migration
  def change
    create_table :sms_rus do |t|
      t.references :organization
      t.string :sender
      t.string :api_id

      t.timestamps
    end
    add_index :sms_rus, :organization_id
  end
end
