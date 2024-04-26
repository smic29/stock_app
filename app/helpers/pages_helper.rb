module PagesHelper
  def get_market_value
    @market_value ||= begin
      total_value = 0
      stock_data = session[:symbol_data]

      stock_data.each do |symbol, data|
        average_price = data["prices"].sum / data["prices"].size.to_f
        user_stock = current_user.stocks.find_by(symbol: symbol)

        if user_stock
          total_value += average_price * user_stock.quantity
        end
      end

      total_value
    end
  end

  def get_transaction_value
    @transaction_value ||= begin
      buy_transactions = current_user.transactions.where(type: 'Buy').sum(:price)
      sell_transactions = current_user.transactions.where(type: 'Sell').sum(:price)

      net_transaction_value = buy_transactions - sell_transactions

      net_transaction_value
    end
  end

  def portfolio_performance_percentage
    @percentage_value ||= begin
      transaction_value = get_transaction_value

      market_value = get_market_value

      percentage_difference = ((market_value - transaction_value) / transaction_value) * 100

      percentage_difference
    end
  end

  def is_gain?
    portfolio_performance_percentage >= 0
  end

  def stock_quantity
    total = 0
    current_user.stocks.each do |stock|
      total += stock.quantity
    end

    total
  end
end
