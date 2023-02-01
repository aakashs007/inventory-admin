class Order < ApplicationRecord
  enum status: [ :created, :in_transit, :recieved ]

  belongs_to :user, class_name: 'User', foreign_key: 'sent_from_user_id'
  belongs_to :user, class_name: 'User', foreign_key: 'sent_to_user_id'

  belongs_to :parent, :class_name => "Order", optional: true
  has_one :child, :class_name => "Order", :foreign_key => :parent_order_id

  has_many :order_products
end