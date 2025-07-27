class AddUniqueIndexToScores < ActiveRecord::Migration[7.2]
  def change
    add_index :scores, [ :user_id, :recorded_on ], unique: true
  end
end
