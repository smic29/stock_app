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
      content_tag(:i, nil, class: "fa-solid fa-money-bill-wave fa-xl txtc-light-blue")
    else
      content_tag(:i, nil, class: "fa-solid fa-hand-holding-dollar fa-xl txtc-air")
    end
  end

  def bought_or_sold_number(transaction)
    verb = is_buy?(transaction) ? 'Bought' : 'Sold'
    noun = pluralize(transaction.quantity, 'share')

    "#{verb} #{noun}"
  end
end
