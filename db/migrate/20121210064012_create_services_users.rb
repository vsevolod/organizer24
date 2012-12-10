class CreateServicesUsers < ActiveRecord::Migration
  def change
    create_table :services_users do |t|
      t.references :service
      t.references :user
      t.references :organization

      t.string     :phone
      t.integer    :cost
      t.integer    :showing_time

      t.timestamps
    end
    add_index :services_users, :service_id
    add_index :services_users, :user_id
    add_index :services_users, :organization_id
    add_index :services_users, :phone
  end
end
