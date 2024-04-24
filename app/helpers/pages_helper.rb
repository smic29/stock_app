module PagesHelper


def get_portfolio_value
  return if session[:symbol_data].nil?

  total_value = 0
  stock_data = session[:symbol_data]

  stock_data.each do |symbol, data|
    average_price = data["prices"].sum / data["prices"].size.to_f
    user_stock = current_user.stocks.find_by(symbol: symbol)

    if user_stock
      total_value += average_price * user_stock.quantity
    end
  end

  total_value / current_user.stocks.not_zero.count
end

end
