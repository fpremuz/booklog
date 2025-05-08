class AddUserIdToTags < ActiveRecord::Migration[8.0]
  def change
    add_reference :tags, :user, foreign_key: true
  end
end
