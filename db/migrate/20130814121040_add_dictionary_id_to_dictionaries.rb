class AddDictionaryIdToDictionaries < ActiveRecord::Migration
  def change
    add_column :dictionaries, :dictionary_id, :integer
    add_index :dictionaries, :dictionary_id

    Dictionary.all.each do |dictionary|
      if dictionary.attributes.include?(:dictionary_id)
        dictionary.update_attribute(:dictionary_id, dictionary.parent_id)
      end
    end
  end
end
