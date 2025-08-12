class MonthlyGoal < ApplicationRecord
  belongs_to :user

  validates :month, presence: true
end
