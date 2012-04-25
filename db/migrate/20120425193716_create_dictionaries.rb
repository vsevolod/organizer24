class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries do |t|
      t.string :name
      t.string :tag
      t.string :ancestry

      t.timestamps
    end
  end
end
