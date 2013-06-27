class CreateAddFioToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.string :lastname
      t.rename :name, :firstname
    end
  end
end
