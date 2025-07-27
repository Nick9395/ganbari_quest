class CreateScores < ActiveRecord::Migration[7.2]
  def change
    create_table :scores do |t|
      t.integer :experience
      t.date :recorded_on

      t.timestamps
    end
  end
end
