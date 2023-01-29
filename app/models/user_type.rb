class UserType < ApplicationRecord
  enum role: [ :super_admin, :admin, :user ]

  has_many :admin_users
  has_many :users
end
