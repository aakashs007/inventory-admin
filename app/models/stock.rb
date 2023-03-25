class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :warehouse
  # validates :product_id, uniqueness: true
end
