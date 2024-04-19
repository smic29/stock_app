module StocksHelper
  def average_buy_price(stock)
    buy_transactions = stock.transactions.where(type: 'Buy')

    total_buy_price = buy_transactions.sum(:price)
    average_buy_price = total_buy_price / buy_transactions.count

    average_buy_price.round(2)
  end

end
