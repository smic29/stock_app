class Transaction < ApplicationRecord
  include Tradeable
  # This is to allow for the usage of the type column by disabling STI.
  # I don't understand what that is at this time. So we try stuff that sticks.
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :stock

  validates :type, inclusion: { in: %w(Buy Sell), message: "%{value} is not a valid transaction type" }
  validates :price, numericality: { greater_than: 0 }
  validate :check_cash_balance, if: :buy_transaction?
  validate :check_stock_quantity, if: :sell_transaction?

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
      operation = commit == 'Buy' ? :increment! : :decrement!
      stock.send(operation, :quantity, create_params[:quantity].to_i)

      # Updating user's cash
      updated_cash = commit == 'Buy' ? cash - total : cash + total
      user.update!(cash: updated_cash)

      return true
    end
  end

  private

  def buy_transaction?
    type == 'Buy'
  end

  def sell_transaction?
    type == 'Sell'
  end

  def check_cash_balance
    return if user.nil? || quantity.nil? || price.nil?

    total_cost = quantity.to_i * price.to_f
    errors.add(:base, 'Insufficient cash balance for this transaction') unless user.cash >= total_cost
  end

  def check_stock_quantity
    return if stock.nil?
    errors.add(:base, 'Cannot sell more stocks than currently owned') if quantity > stock.quantity
  end

end
