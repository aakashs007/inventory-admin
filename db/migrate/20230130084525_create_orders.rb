class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :status
      # t.references :user, null: false, foreign_key: { to_table: :users, name: :sent_from_user_id }
      # t.references :user, null: false, foreign_key: { to_table: :users, name: :sent_to_user_id }

      t.timestamps
    end

    add_column :orders, :sent_from_user_id, :integer, null: false, index: true
    add_foreign_key :orders, :users, column: :sent_from_user_id    

    add_column :orders, :sent_to_user_id, :integer, null: false, index: true
    add_foreign_key :orders, :users, column: :sent_to_user_id 

    add_column :orders, :parent_order_id, :integer, null: true, index: true
    add_foreign_key :orders, :orders, column: :parent_order_id
  end
end
