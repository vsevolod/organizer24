class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :permalink
      t.text :content
      t.references :organization

      t.timestamps
    end
    add_index :pages, :permalink
    add_index :pages, :organization_id
  end
end
