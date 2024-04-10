class PagesController < ApplicationController
  def home
    redirect_to admin_path if current_user&.admin
  end
end
