class RemoveExtraContentFromCollege < ActiveRecord::Migration
  def up
    remove_column :colleges, :extra_content
  end

  def down
    add_column :colleges, :extra_content, :string
  end
end
