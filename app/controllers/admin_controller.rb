class AdminController < ApplicationController
  before_action :has_admin_access

  def home

  end

  def pending

  end
end
