class Admin::UsersController < ApplicationController
  before_action :has_admin_access, only: [ :index, :new, :show, :edit, :update ]
  before_action :set_user, only: [ :show, :edit, :update ]

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
        flash[:notice] = 'User successfully created. Email sent'
        format.turbo_stream { render turbo_stream: [
          turbo_stream.append("alert-container", partial: "shared/alerts")
        ]}
        AdminMailer.with(user: @user, password: @password).welcome_email.deliver_later
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show

  end

  def edit

  end

  def update
    if @user.update(user_params)
      respond_to do |format|
        flash[:notice] = "Successfully updated user"
        format.html { redirect_to @user }
        format.turbo_stream { render turbo_stream: [
          turbo_stream.append("alert-container", partial: "shared/alerts"),
          turbo_stream.replace("modal_frame", template: "admin/users/show")
        ]}
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:email, :cash, :password, :password_confirmation, :approved, :name)
  end
end
