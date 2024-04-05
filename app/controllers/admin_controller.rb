class AdminController < ApplicationController
  before_action :has_admin_access, only: [ :index ]

  def index
    @users = User.all
  end

  private

  def has_admin_access
    redirect_to root_path if !current_user&.admin
  end
end
