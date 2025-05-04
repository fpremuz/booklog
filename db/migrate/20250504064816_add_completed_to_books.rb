class AddCompletedToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :completed, :boolean
  end
end
