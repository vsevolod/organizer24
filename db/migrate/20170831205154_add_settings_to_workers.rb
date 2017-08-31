class AddSettingsToWorkers < ActiveRecord::Migration[5.0]
  OLD_COLUMNS = %w[
    profession
    dative_case
    push_key
    sms_translit
  ]

  def change
    add_column :workers, :settings, :jsonb, null: false, default: {}

    Worker.all.each do |worker|
      OLD_COLUMNS.each do |key|
        worker.settings[key] = worker.public_send(key)
      end
      worker.save
    end

    remove_columns :workers, *OLD_COLUMNS
  end
end
