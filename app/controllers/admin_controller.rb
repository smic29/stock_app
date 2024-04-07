class AdminController < ApplicationController
  before_action :has_admin_access, only: [ :index ]
  include PasswordGenerator

  helper_method :generate_random_password

  def index
    @users = User.all.where.not(id: current_user.id)
  end

  def new
    @user = User.new
    @random_password = generate_random_password
  end

  def create
    @user = User.new(user_params)
  end

  private

  def has_admin_access
    redirect_to root_path if !current_user&.admin
  end

  def user_params
    params.require(:user).permit(:email, :cash, :password, :approved)
  end
end
