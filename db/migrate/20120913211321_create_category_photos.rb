class CreateCategoryPhotos < ActiveRecord::Migration
  def change
    create_table :category_photos do |t|
      t.string :name
      t.string :ancestry
      t.references :organization

      t.timestamps
    end
    add_index :category_photos, :ancestry
    add_index :category_photos, :organization_id
  end
end
