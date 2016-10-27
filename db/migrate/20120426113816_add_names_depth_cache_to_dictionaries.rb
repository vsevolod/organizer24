class AddNamesDepthCacheToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :names_depth_cache, :string
  end
end
