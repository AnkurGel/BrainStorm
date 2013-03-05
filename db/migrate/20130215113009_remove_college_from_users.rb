class RemoveCollegeFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :college
  end

  def down
    add_column :users, :college, :string
  end
end
