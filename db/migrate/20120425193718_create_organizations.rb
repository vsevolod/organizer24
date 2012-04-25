class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.references :activity
      t.string :subdomain
      t.references :owner

      t.timestamps
    end
  end
end
