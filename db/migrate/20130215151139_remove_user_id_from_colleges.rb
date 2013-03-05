class RemoveUserIdFromColleges < ActiveRecord::Migration
  def up
    remove_column :colleges, :user_id
  end

  def down
  end
end
