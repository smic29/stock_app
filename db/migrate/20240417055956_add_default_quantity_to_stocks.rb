class AddDefaultQuantityToStocks < ActiveRecord::Migration[7.1]
  def change
    change_column_default :stocks, :quantity, 0
  end
end
