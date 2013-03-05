class AddHintToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :hint, :string
  end
end
