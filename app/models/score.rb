class Score < ApplicationRecord
  belongs_to :user

  validates :recorded_on, presence: true # recorded_onカラム(日付)の空白禁止
  validates :experience, presence: true, numericality: { only_integer: true } # 空白禁止、数値であり整数であることをチェック
end
