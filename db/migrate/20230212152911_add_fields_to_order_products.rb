class AddFieldsToOrderProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :order_products, :quantity, :integer, null: true
    add_column :order_products, :unit, :float, null: true
  end
end
