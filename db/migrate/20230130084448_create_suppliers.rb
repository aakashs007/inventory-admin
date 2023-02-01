class CreateSuppliers < ActiveRecord::Migration[7.0]
  def change
    create_table :suppliers do |t|
      t.string :name
      t.string :phone_number
      t.string :email
      t.text :address
      t.boolean :active, default: true

      t.timestamps
    end
  end
end
