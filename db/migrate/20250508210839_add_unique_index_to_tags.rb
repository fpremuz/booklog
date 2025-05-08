class AddUniqueIndexToTags < ActiveRecord::Migration[8.0]
  def change
    remove_index :tags, [:user_id, :name] if index_exists?(:tags, [:user_id, :name])
    add_index :tags, 'lower(name), user_id', unique: true, name: 'index_tags_on_lower_name_and_user_id'
  end
end
