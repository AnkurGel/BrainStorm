class AddLastCorrectAnswerAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_correct_answer_at, :datetime
  end
end
