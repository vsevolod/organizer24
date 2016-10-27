class RemoveExecutors < ActiveRecord::Migration
  def up
    drop_table :executors
  end

  def down
    create_table :executors do |t|
      # ...
    end
  end
end
