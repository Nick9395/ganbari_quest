class User < ApplicationRecord
  has_secure_password
  has_many :battles
  has_many :scores, dependent: :destroy # テーブル紐づけ＆userが削除されると紐づいたscoreも削除
  has_many :monthly_goals, dependent: :destroy

  validates :name, presence: true, length: { maximum: 20 }
  validates :email, presence: true, uniqueness: true, length: { maximum: 50 }
  validates :password,
            presence: true,
            length: { minimum: 4, maximum: 12 },
            format: { with: /\A[a-zA-Z0-9]+\z/, message: :format },
            if: :password_digest_changed?

  validates :password_confirmation, presence: true, if: :password_digest_changed?

  # 以下未検証のコード
  MAX_EXPERIENCE = 7984
  MAX_LEVEL = 999

  # 現在の経験値の合計
  def total_experience
    scores.sum(:experience)
  end

  # レベル計算（経験値からレベルへの変換ルールを仮にここで）
  def level
    # 仮の変換：経験値8ごとに1レベル上がるとする
    [ total_experience / 8, MAX_LEVEL ].min
  end
end
