class TransactionsController < ApplicationController

  def create
    type = params[:commit]
    # stock = current_user.stocks.find_or_create_by(symbol: params[:symbol])
    stock = params[:symbol].upcase
    price = params[:price].to_f
    total = params[:quantity].to_f * price

    puts "You're going to #{type} #{stock} for #{price} per, totalling to #{total}"

  end

end
