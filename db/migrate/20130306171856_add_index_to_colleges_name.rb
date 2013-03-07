class AddIndexToCollegesName < ActiveRecord::Migration
  def change
    add_index :colleges, :name, unique: true
    add_column :colleges, :extra_content, :string
  end
end
