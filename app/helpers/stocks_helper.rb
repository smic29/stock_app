module StocksHelper
  def average_buy_price(stock)
    buy_transactions = stock.transactions.where(type: 'Buy')

    total_buy_price = buy_transactions.sum(:price)
    average_buy_price = total_buy_price / buy_transactions.count

    average_buy_price.round(2)
  end

  def total_value(stock)
    stock.quantity * average_buy_price(stock)
  end

  def previous_close_price(stock, cached_data)
    cached_data[stock]['previousClose']
  end

end
