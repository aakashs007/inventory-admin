class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to :user_type
  belongs_to :warehouse, optional: true
  has_one :user_info, dependent: :destroy

  has_many :sent_from_orders, class_name: "Order", foreign_key: :sent_from_user_id
  has_many :sent_to_orders, class_name: "Order", foreign_key: :sent_to_user_id

  has_one :supplier, class_name: "Product", foreign_key: :supplier_id

  def jwt_payload
    super.merge('id' => id, 'email' => email)
  end
end
