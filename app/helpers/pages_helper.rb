module PagesHelper
  def get_market_value
    @market_value ||= begin
      total_value = 0
      stock_data = session[:symbol_data]

      # Keeping this for the time being since this is the first method I did.
      # stock_data.each do |symbol, data|
      #   next if data.nil? || data == 'No data found'
      #   user_stock = current_user.stocks.find_by(symbol: symbol)

      #   average_price = data["prices"].sum / data["prices"].size.to_f

      #   if user_stock
      #     total_value += average_price * user_stock.quantity
      #   end
      # end

      user_stocks = current_user.stocks

      user_stocks.each do |stock|
        prices = stock_data[stock.symbol]["prices"]
        market_value = prices.sum / prices.size.to_f

        total_value += market_value * stock.quantity
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
