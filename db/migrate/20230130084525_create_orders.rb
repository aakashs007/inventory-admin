class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :status
      t.integer :transfer_type
      t.integer :order_type
      t.integer :payment_mode
      t.string :issued_for_client_name
      t.text :issued_for_client_address
      t.string :issued_for_client_pincode
      t.string :service_report_number
      t.string :delievery_challan_number
      t.datetime :sent_at
      t.datetime :recieved_at

      t.timestamps
    end

    add_column :orders, :sent_from_user_id, :integer, null: false, index: true
    add_foreign_key :orders, :users, column: :sent_from_user_id    

    add_column :orders, :sent_to_user_id, :integer, null: true, index: true
    add_foreign_key :orders, :users, column: :sent_to_user_id 

    add_column :orders, :parent_order_id, :integer, null: true, index: true
    add_foreign_key :orders, :orders, column: :parent_order_id, on_delete: :cascade
  end
end
