class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to :user_type
  has_one :user_info, dependent: :destroy

  has_many :orders, class_name: 'User', foreign_key: 'sent_from_user_id'
  has_many :orders, class_name: 'User', foreign_key: 'sent_to_user_id'

  def jwt_payload
    super.merge('id' => id, 'email' => email)
  end
end
