class Admin::UsersController < ApplicationController
  before_action :has_admin_access, only: [ :index, :new, :show ]
  before_action :set_user, only: [ :show ]

  include PasswordGenerator

  helper_method :generate_random_password

  def index
    @users = User.is_a_user
  end

  def new
    @user = User.new
    @random_password = generate_random_password
  end

  def create
    @user = User.new(user_params)
    @user.skip_confirmation!
    @password = user_params[:password]

    respond_to do |format|
      if @user.save
        format.turbo_stream
        AdminMailer.with(user: @user, password: @password).welcome_email.deliver_later
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :cash, :password, :password_confirmation, :approved)
  end
end
