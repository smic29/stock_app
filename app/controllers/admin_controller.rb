class AdminController < ApplicationController
  before_action :has_admin_access

  def index

  end
end
