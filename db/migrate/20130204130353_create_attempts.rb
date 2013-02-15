class CreateAttempts < ActiveRecord::Migration
  def change
    create_table :attempts do |t|
      t.string :attempt
      t.integer :user_id
      t.integer :level_id

      t.timestamps
    end
  end
end
