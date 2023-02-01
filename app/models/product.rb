class Product < ApplicationRecord
  belongs_to :supplier
  has_one :stock, dependent: :destroy
  has_many :order_products
end
