class MakeUserIdNotNullOnTags < ActiveRecord::Migration[8.0]
  def change
    change_column_null :tags, :user_id, false
  end
end
