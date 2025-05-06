class RemoveCompletedFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :completed, :boolean
  end
end
