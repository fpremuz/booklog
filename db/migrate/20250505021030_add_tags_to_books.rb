class AddTagsToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :tags, :string
  end
end
