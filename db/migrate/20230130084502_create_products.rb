class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :name
      t.boolean :active, default: true
      t.string :slug
      t.float :price, default: 0.0
      t.float :vat

      t.timestamps
    end
  end
end
