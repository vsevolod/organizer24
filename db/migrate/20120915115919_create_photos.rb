class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.references :category_photo

      t.timestamps
    end
    add_attachment :photos, :photo
    add_index :photos, :category_photo_id
  end
end
