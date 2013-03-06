class AddFieldsToLevel < ActiveRecord::Migration
  def change
    add_column :levels, :title, :string
    add_column :levels, :alt, :string
  end
end
