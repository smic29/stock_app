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
    @user.skip_confirmation!

    respond_to do |format|
      if @user.save
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  private

  def has_admin_access
    redirect_to root_path if !current_user&.admin
  end

  def user_params
    params.require(:user).permit(:email, :cash, :password, :password_confirmation, :approved)
  end
end
