class FixNullUserIdInTags < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!

  def up
    default_user_id = User.first&.id
    raise "No users found! Create at least one user before running this migration." unless default_user_id

    say_with_time "Assigning default user_id to tags with nil user_id..." do
      Tag.where(user_id: nil).update_all(user_id: default_user_id)
    end

    change_column_null :tags, :user_id, false
  end

  def down
    change_column_null :tags, :user_id, true
  end
end
