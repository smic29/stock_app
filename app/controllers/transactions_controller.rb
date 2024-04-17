class TransactionsController < ApplicationController

  def create
    # type = params[:commit]
    # stock = current_user.stocks.find_or_create_by(symbol: params[:symbol])
    # stock = params[:symbol].upcase
    # price = params[:price].to_f
    # total = params[:quantity].to_f * price

    if params[:commit] == 'Buy'

      ActiveRecord::Base.transaction do
        # Params required for transaction creation
        create_params = transaction_params
        create_params[:type] = params[:commit]
        @stock = current_user.stocks.find_or_create_by(symbol: create_params[:symbol].upcase)
        create_params[:stock_id] = @stock.id
        create_params = create_params.except(:symbol) # Needed to remove since it's not part of the transactions table
        price = create_params[:price].to_f
        total = create_params[:quantity].to_f * price
        cash = current_user.cash

        # Creating the transaction
        @transaction = current_user.transactions.new(create_params)
        @transaction.save!

        # Updating the stock
        @stock.increment!(:quantity, create_params[:quantity].to_i)

        # Updating current cash
        current_user.update!(cash: cash - total)
      end


    end
  end

  private

  def transaction_params
    params.require(:transaction).permit(:symbol, :price, :quantity)
  end

end
