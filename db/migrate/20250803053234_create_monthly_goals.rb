class CreateMonthlyGoals < ActiveRecord::Migration[7.2]
  def change
    create_table :monthly_goals do |t|
      t.references :user, null: false, foreign_key: true
      t.string :target_text
      t.string :evaluation_text
      t.string :review_text
      t.date :month

      t.timestamps
    end
  end
end
