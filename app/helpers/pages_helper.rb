module PagesHelper
  def get_market_value
    @market_value ||= begin
      total_value = 0
      stock_data_service = StockDataService.new
      stock_data = stock_data_service.retrieve_stock_data_from_redis(current_user)

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

  def price_arrow
    arrow = rand(1..2)

    if arrow == 1
      "<i class='fa-solid fa-arrow-up fa-xs text-success'></i>".html_safe
    else
      '<i class="fa-solid fa-arrow-down fa-xs text-danger"></i>'.html_safe
    end
  end

  def compare_arrow(price, comparison)
    if price > comparison
      "<i class='fa-solid fa-arrow-up fa-sm text-success'></i>".html_safe
    else
      '<i class="fa-solid fa-arrow-down fa-sm text-danger"></i>'.html_safe
    end
  end

  def get_share_quantity(symbol)
    current_user.stocks.not_zero.find_by(symbol: symbol).quantity
  end
end
