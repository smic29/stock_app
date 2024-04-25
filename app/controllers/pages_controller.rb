class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :quote, :dashboard, :chart_data ]

  def home
    redirect_to admin_path if current_user&.admin

  end

  def dashboard
    save_stock_data_to_cookies if current_user
  end

  def quote

    respond_to do |format|
      @data = lookup_symbol(params[:symbol])

      format.turbo_stream
    end if request.post?
  end

  def chart_data
    transactions = current_user.transactions.where("created_at >= ?", 7.days.ago)

    # Group transactions by day
    grouped_transactions = transactions.group_by { |transaction| transaction.created_at.to_date }

    labels = []
    buy_data = []
    sell_data = []

    # Iterate over each day and count the number of buy and sell transactions
    grouped_transactions.each do |date, transactions|
      labels << date.strftime("%m-%d")

      buy_count = transactions.count { |transaction| transaction.type == 'Buy' }
      sell_count = transactions.count { |transaction| transaction.type == 'Sell' }

      buy_data << buy_count
      sell_data << sell_count
    end

    render json: { labels: labels, buy_data: buy_data, sell_data: sell_data }
  end

  private

  def lookup_symbol(symbol)
    query = YahooFinance::Query.new
    data = query.quote(symbol)

    data
  end

  def save_stock_data_to_cookies
    if session[:symbol_data].nil? || session[:symbol_data_updated_at].nil? || session[:symbol_data_updated_at] < 24.hours.ago
      session[:symbol_data] = lookup_symbol(current_user.stocks.not_zero.distinct.pluck(:symbol))
      session[:symbol_data_updated_at] = Time.current
    end
  end

end
