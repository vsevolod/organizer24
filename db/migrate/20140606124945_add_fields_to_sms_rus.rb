class AddFieldsToSmsRus < ActiveRecord::Migration
  def change
    add_column :sms_rus, :translit, :boolean, null: false, default: false
    add_column :sms_rus, :balance, :float
  end
end
