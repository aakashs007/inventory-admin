class AddUserTypeIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :admin_users, :user_type_id, :integer
    add_index :admin_users, :user_type_id
    add_foreign_key :admin_users, :user_types, on_delete: :cascade

    add_column :users, :user_type_id, :integer
    add_index :users, :user_type_id
    add_foreign_key :users, :user_types, on_delete: :cascade
  end
end
