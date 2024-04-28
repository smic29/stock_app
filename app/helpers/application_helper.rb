module ApplicationHelper
  def pending_users_count
    User.is_pending_approval.count
  end

  def pending_users?
    User.is_pending_approval.exists?
  end

  def pending_users_link
    link_to pending_approval_path, data: { turbo_frame: 'admin_dash' },
      class: "txtc-air dash-link #{pending_users? ? '' : 'disabled' }" do
        if pending_users?
          content_tag(:i, '', class: 'fa-solid fa-person-circle-exclamation fa-xl')
        else
          content_tag(:i, '', class: 'fa-solid fa-person fa-xl')
        end
      end
  end

  def nav_link(path, frame, icon, active = false)
    user_tag = current_user.admin? ? '' : 'user-link'

    link_to path, data: { turbo_frame: frame }, class: "txtc-air dash-link #{active ? 'active' : ''}" do
      content_tag(:i, '', class: "fa-solid fa-xl #{icon} #{user_tag}")
    end
  end
end
