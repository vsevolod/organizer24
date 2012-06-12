class CreateCollectionsServices < ActiveRecord::Migration
  def change
    create_table :collections_services do |t|
      t.integer :service_id
      t.integer :collection_id

      t.timestamps
    end

    add_column :services, :is_collection, :boolean
  end
end
