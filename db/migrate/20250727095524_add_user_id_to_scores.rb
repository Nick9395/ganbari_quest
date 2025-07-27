class AddUserIdToScores < ActiveRecord::Migration[7.2]
  def change
    add_reference :scores, :user, null: false, foreign_key: true
  end
end
