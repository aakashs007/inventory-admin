class UserInfo < ApplicationRecord
  belongs_to :user
  enum gender: [ :male, :female, :other ]
  validates :user_id, uniqueness: true
end
