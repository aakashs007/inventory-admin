class CreateUserTypeTableAddSomeMore < ActiveRecord::Migration[7.0]
  def change
    create_table :user_types do |t|
      t.integer :role

      t.timestamps
    end
  end
end
