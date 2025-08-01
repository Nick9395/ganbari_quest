class User < ApplicationRecord
  has_secure_password
  has_many :battles
  has_many :scores

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true # 空欄禁止と重複禁止を設定
end
