class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.boolean :is_playable, :default => false
      t.timestamps
    end
  end
end
