class AddWarehouseTable < ActiveRecord::Migration[7.0]
  def change
    create_table :warehouses do |t|
      t.string :name
      t.text :address
      t.string :pincode

      t.timestamps
    end

    add_column :users, :warehouse_id, :integer, null: true, index: true
    add_foreign_key :users, :warehouses, column: :warehouse_id    

    add_column :stocks, :warehouse_id, :integer, null: false, index: true
    add_foreign_key :stocks, :warehouses, column: :warehouse_id

    add_column :orders, :issued_to_warehouse_id, :integer, null: true, index: true
    add_foreign_key :orders, :warehouses, column: :issued_to_warehouse_id

    add_column :stocks, :unit, :float, null: true

    add_column :products, :supplier_id, :integer, null: true, index: true
    add_foreign_key :products, :users, column: :supplier_id
  end
end
