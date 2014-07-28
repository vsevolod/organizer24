class AddDativeCaseForWorkers < ActiveRecord::Migration
  def up
    add_column :workers, :dative_case, :string
  end

  def down
    remove_column :workers, :dative_case
  end
end
