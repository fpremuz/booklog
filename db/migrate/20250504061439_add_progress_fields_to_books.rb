class AddProgressFieldsToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :start_date, :date
    add_column :books, :finish_date, :date
    add_column :books, :pages_read, :integer
    add_column :books, :total_pages, :integer
    add_column :books, :reading_notes, :text
  end
end
