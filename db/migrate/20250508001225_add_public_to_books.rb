class AddPublicToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :public, :boolean
  end
end
