require 'yahoo_finance'

class AdminController < ApplicationController
  before_action :has_admin_access

  def home
    @user_count = User.is_a_user.count
    @trader_request_count = User.is_pending_approval.count
    @verified_traders_count = User.is_verified_trader.count

    query = YahooFinance::Query.new
    @data = query.quote('nba')['nba']
    #aapl used for testing
  end

  def pending
    @users = User.is_pending_approval.order(:confirmed_at)
  end
end
