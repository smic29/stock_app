class AddConstraintToCashColumn < ActiveRecord::Migration[7.1]
  def change
    change_column :users, :cash, :decimal, precision: 10, scale: 2, default: 5000
    add_check_constraint :users, 'cash >= 0', name: 'check_cash_non_negative'
  end
end
