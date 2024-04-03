class AddCashToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :cash, :decimal, default: 5000
  end
end
