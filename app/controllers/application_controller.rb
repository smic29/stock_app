class ApplicationController < ActionController::Base
  layout :set_layout

  private

  def set_layout
    if current_user&.admin?
      "admin"
    else
      "application"
    end
  end

  def has_admin_access
    redirect_to root_path if !current_user&.admin
  end

end
