class Admin::UsersController < ApplicationController
  before_action :has_admin_access, only: [ :index, :new ]
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

  private

  def user_params
    params.require(:user).permit(:email, :cash, :password, :password_confirmation, :approved)
  end
end
