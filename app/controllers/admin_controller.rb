class AdminController < ApplicationController
  before_action :has_admin_access
  before_action :set_user, only: [:approve]

  def home
    @user_count = User.is_a_user.count
    @trader_request_count = User.is_pending_approval.count
    @verified_traders_count = User.is_verified_trader.count
  end

  def pending
    @users = User.is_pending_approval.order(:confirmed_at)
  end

  def approve
    unless @user.approved && @user.confirmed?
      if @user.update(approved: true)
        respond_to do |format|
          format.turbo_stream
        end
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
