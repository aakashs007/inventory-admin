class Warehouse < ApplicationRecord
  has_one :user
  has_many :stocks
  has_many :issued_to_warehouse, class_name: "Order", foreign_key: :issued_to_warehouse_id
end
