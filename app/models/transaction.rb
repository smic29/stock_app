class Transaction < ApplicationRecord
  include Tradeable
  # This is to allow for the usage of the type column by disabling STI.
  # I don't understand what that is at this time. So we try stuff that sticks.
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :stock

  def self.transact(user, commit, transaction_params)
    ActiveRecord::Base.transaction do
      # Prepare parameters for transaction create
      create_params = transaction_params
      create_params[:type] = commit
      symbol = create_params[:symbol].upcase if create_params[:symbol].present?
      stock = user.stocks.find_or_create_by(symbol: symbol)
      create_params[:stock_id] = stock.id
      create_params = create_params.except(:symbol)

      # Prepare calculation variables
      price = create_params[:price].to_f
      total = create_params[:quantity].to_f * price
      cash = user.cash

      # Create the transaction
      transaction = user.transactions.new(create_params)
      transaction.save!

      # Update the stock
      commit == 'Buy' ? stock.increment!(:quantity, create_params[:quantity].to_i) : stock.decrement!(:quantity, create_params[:quantity].to_i)

      # Updating user's cash
      commit == 'Buy' ? user.update!(cash: cash - total) : user.update!(cash: cash + total)

      return true
    end
  end
end
