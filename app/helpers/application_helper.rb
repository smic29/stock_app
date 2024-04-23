module ApplicationHelper
  def pending_users_count
    User.is_pending_approval.count
  end

  def pending_users?
    User.is_pending_approval.exists?
  end
end
