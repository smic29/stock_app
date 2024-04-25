class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :quote ]

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
