# Used to override will_paginate's link renderer
# This file is heavily AI-prompted but will be a good reference to understand helpers more.
class BootstrapLinkRenderer < WillPaginate::ActionView::LinkRenderer
  COLORS = {
    dark_blue: '#31708e',
    air: '#f7f9fb',
    light_blue: '#8fc1e3',
    default_text: '#333333'
  }

  protected

  def page_number(page)
    link_class = 'page-link user-select-none text-reset txtc-dark-blue'
    link_class << ' disabled' if page == current_page
    item_class = 'page-item'
    item_class << ' active' if page == current_page
    item_style = page_style(page)

    tag(:li, link(page, page, class: link_class), class: item_class, style: item_style)
  end

  def gap
    text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
    tag(:li, link(text, nil, class: 'page-link disabled user-select-none'), class: 'page-item')
  end

  def previous_or_next_page(page, text, classname, aria_label = nil)
    link_class = 'page-link user-select-none text-reset'
    link_class << ' disabled' if page.nil?
    item_class = "page-item #{classname}"
    item_style = page_style(page)

    if page
      tag(:li, link(text, page, class: link_class, 'aria-label' => aria_label), class: item_class, style: item_style)
    else
      tag(:li, tag(:span, text, class: "#{link_class} #{classname} disabled", 'aria-label' => aria_label), class: 'page-item')
    end
  end

  def link(text, target, attributes = {})
    if target.is_a?(Integer)
      attributes[:rel] = rel_value(target)
      target = url(target)
    end

    attributes[:href] = target

    tag(:a, text, attributes)
  end

  def page_style(target)
    if target == current_page
      "background-color: #{COLORS[:dark_blue]}; color: #{COLORS[:dark_blue]}; border-color: #{COLORS[:light_blue]};"
    elsif target.nil?
      "background-color: #{COLORS[:air]}; color: #{COLORS[:dark_blue]}; border-color: #{COLORS[:light_blue]};"
    else
      "background-color: #{COLORS[:air]}; color: #{COLORS[:dark_blue]}; border-color: #{COLORS[:light_blue]};"
    end
  end

  def container_attributes
    super.except(*[:aria_label])
  end

  def html_container(html)
    tag(:nav, tag(:ul, html, class: 'pagination'), container_attributes)
  end
end
