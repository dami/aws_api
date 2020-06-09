class CreateStocks < ActiveRecord::Migration[6.0]
  def change
    create_table :stocks do |t|
      t.string :name
      t.integer :amount
      t.float :sale

      t.timestamps
    end
  end
end
