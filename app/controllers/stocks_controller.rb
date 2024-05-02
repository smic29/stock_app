class StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    @cached_data = StockDataService.new.retrieve_stock_data_from_redis(current_user)
    @stocks = current_user.stocks.displayable

  end
end
