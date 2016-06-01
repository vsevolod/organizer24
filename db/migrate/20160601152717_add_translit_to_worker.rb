class AddTranslitToWorker < ActiveRecord::Migration
  def change
    add_column :workers, :sms_translit, :boolean
  end
end
