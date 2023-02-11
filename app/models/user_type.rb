class UserType < ApplicationRecord
  enum role: [ :super_admin, :admin, :warehouse_admin, :warehouse_user, :site_engineer, :supplier ]

  has_many :admin_users
  has_many :users
end
