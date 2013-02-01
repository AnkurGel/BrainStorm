class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.string :question
      t.string :answer
      t.integer :prev_id
      t.integer :next_id

      t.timestamps
    end
  end
end
