class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.integer :quantity, default: 0
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
