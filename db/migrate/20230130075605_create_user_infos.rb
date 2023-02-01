class CreateUserInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :user_infos do |t|
      t.string :first_name
      t.string :last_name
      t.integer :age
      t.integer :latitude
      t.integer :longitude
      t.string :phone_number
      t.integer :gender
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end

    # add_column :user_infos, :user_id, :id
    # add_index :user_infos, :user_id
    # add_foreign_key :user_infos, :users, on_delete: :cascade
  end
end
