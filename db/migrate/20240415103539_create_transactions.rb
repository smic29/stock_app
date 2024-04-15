class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.string :type
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
