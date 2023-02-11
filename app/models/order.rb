class Order < ApplicationRecord
  enum status: [ :created, :sent, :recieved ]
  enum order_type: [:purchase, :stock_transfer, :replacement, :return, :removed, :repaired, :distribution_sale, :installation, :complaint, :amc]
  enum payment_mode: [:bill, :cash, :gate_pass]
  enum transfer_type: [:in, :out]

  belongs_to :sent_from_user, class_name: "User", foreign_key: :sent_from_user_id
  belongs_to :sent_to_user, class_name: "User", foreign_key: :sent_to_user_id, optional: true

  belongs_to :parent, :class_name => "Order", optional: true
  has_one :child, :class_name => "Order", :foreign_key => :parent_order_id, dependent: :destroy

  has_many :order_products
  belongs_to :issued_to_warehouse, class_name: "Warehouse", foreign_key: :issued_to_warehouse_id, optional: true
end