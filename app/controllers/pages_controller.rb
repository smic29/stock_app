class PagesController < ApplicationController
  def home
    redirect_to admin_path if current_user&.admin

    query = YahooFinance::Query.new
    @data = query.quote('nvda')['nvda']
    #aapl used for testing
  end

  def quote

  end
end
