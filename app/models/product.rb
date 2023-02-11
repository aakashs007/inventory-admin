class Product < ApplicationRecord
  belongs_to :supplier, class_name: "User", foreign_key: :supplier_id, optional: true
  has_one :stock, dependent: :destroy
  has_many :order_products
end
