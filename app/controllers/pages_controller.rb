class PagesController < ApplicationController
  def home
    redirect_to admin_index_path if current_user&.admin
  end
end
