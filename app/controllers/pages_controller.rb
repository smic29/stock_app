class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :quote, :dashboard, :chart_data ]

  def home
    redirect_to admin_path if current_user&.admin

  end

  def dashboard
    save_stock_data_to_cookies if current_user
  end

  def quote
    @samples = TickerGenerator.generate_samples(3)
    @owned_tickers = current_user.stocks

    respond_to do |format|
      symbol = params[:symbol]

      unless session[:symbol_data][symbol]
        session[:symbol_data].update(lookup_symbol(symbol))
      end

      @data = session[:symbol_data][symbol]

      puts @data
      puts session[:symbol_data][params[:symbol]]

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
    @data = {
      today: { buy: 0, sell: 0, count: 0 },
      yesterday: { buy: 0, sell: 0, count: 0 },
      week: { buy: 0, sell: 0, count: 0 }
    }

    # Iterate over each day and count the number of buy and sell transactions
    grouped_transactions.each do |date, transactions|
      labels << date.strftime("%m-%d")

      buy_count = 0
      sell_count = 0
      buy_price = 0
      sell_price = 0

      transactions.each do |transaction|
        if transaction.type == 'Buy'
          buy_count += 1
          buy_price += transaction.price.to_f
        else
          sell_count += 1
          sell_price += transaction.price.to_f
        end
      end

      buy_data << buy_count
      sell_data << sell_count

      if date == Date.today
        @data[:today][:buy] = buy_price
        @data[:today][:sell] = sell_price
        @data[:today][:count] = buy_count + sell_count
      elsif date == Date.today - 1
        @data[:yesterday][:buy] = buy_price
        @data[:yesterday][:sell] = sell_price
        @data[:yesterday][:count] = buy_count + sell_count
      end

      if date >= Date.today - 7
        @data[:week][:buy] += buy_price
        @data[:week][:sell] += sell_price
        @data[:week][:count] += buy_count + sell_count
      end
    end

    respond_to do |format|
      format.json { render json: { labels: labels, buy_data: buy_data, sell_data: sell_data } }
      format.turbo_stream {
        render turbo_stream: [
          turbo_stream.update("user_transactions_table", partial: "pages/dashboard/transaction/table", locals: { data: @data })
        ] }
    end
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
