class PagesController < ApplicationController
  before_action :authenticate_user!, only: [ :quote ]

  def home
    redirect_to admin_path if current_user&.admin

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

end
