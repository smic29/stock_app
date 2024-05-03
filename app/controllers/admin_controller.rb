class AdminController < ApplicationController
  before_action :has_admin_access
  before_action :set_user, only: [:approve]

  def home
  end

  def dashboard
    @transactions = Transaction.all.order(created_at: :desc).limit(5)
  end

  def pending
    @users = User.is_pending_approval.order(confirmed_at: :desc)
  end

  def approve
    if !@user.approved && @user.confirmed?
      if @user.update(approved: true)
        flash[:notice] = "User has been approved. Email Sent"
        respond_to do |format|
          format.turbo_stream
        end
        AdminMailer.with(user: @user).trade_approved_email.deliver_later
      end
    end
  end

  def chart_data
    users = User.is_a_user.count
    verified_users = User.is_verified_trader.count
    pending_users = User.is_pending_approval.count
    unconfirmed_users = users - (verified_users + pending_users)

    render json: { labels: ['verified','pending','unconfirmed'], verified: verified_users, pending: pending_users, unconfirmed: unconfirmed_users }
  end

  def transactions
    @transactions = Transaction.all.order(created_at: :desc)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
