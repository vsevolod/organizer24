class AddOrganizationIdToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :organization_id, :integer
    add_index :dictionaries, :organization_id
  end
end
