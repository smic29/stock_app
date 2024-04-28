module AdminHelper
  def user_count
    User.is_a_user.count
  end

  def trader_request_count
    User.is_pending_approval.count
  end

  def verified_traders_count
    User.is_verified_trader.count
  end

  def is_buy?(transaction)
    transaction.type == 'Buy'
  end

  def render_icon(transaction)
    if is_buy?(transaction)
      content_tag(:i, nil, class: "fa-solid fa-money-bill-wave fa-xl txtc-sunset")
    else
      content_tag(:i, nil, class: "fa-solid fa-hand-holding-dollar fa-xl txtc-dark-blue")
    end
  end
end
