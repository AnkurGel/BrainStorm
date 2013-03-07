class AddExtraContentToLevel < ActiveRecord::Migration
  def change
    add_column :levels, :extra_content, :string
  end
end
