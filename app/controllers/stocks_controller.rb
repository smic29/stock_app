class StocksController < ApplicationController
  before_action :authenticate_user!

  def index
    @stocks = current_user.stocks.where("quantity > ?", 0 )
  end
end
