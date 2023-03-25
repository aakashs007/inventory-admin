class ChangeColumnNameToIntegerInOrderProducts < ActiveRecord::Migration[7.0]
  def up
    remove_column :order_products, :unit
    remove_column :stocks, :unit
    add_column :products, :unit, :integer, null: true
    # change_column :order_products, :unit, :integer
    # change_column :stocks, :unit, :integer
  end

  def down
    change_column :order_products, :unit, :float
    change_column :stocks, :unit, :float
  end
end