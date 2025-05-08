class BackfillUsernames < ActiveRecord::Migration[7.1]
  def up
    User.where(username: nil).find_each do |user|
      user.update(username: "user#{user.id}")
    end
  end

  def down
  end
end