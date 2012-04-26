# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module PathBarHelper

  def self.included(base)
    base.send :include, Rails.application.routes.url_helpers
  end

  # Path bar element with no link
  def path_bar_element_with_no_link(text)
    text
  end
  def path_bar_element_with_no_link?(element)
    element.instance_of?(String)
  end

  # path bar element with a default link (current controller and action)
  # ignores eventual GET parameters
  def path_bar_element_for_current_resource(text)
    [text]
  end

  # path bar element with a link to url_for(options)
  def path_bar_element(text, url_for_options = {})
    [text, url_for_options]
  end

  def path_bar_dishes_root
    path_bar_element('Recettes', dishes_path)
  end

  def path_bar_items_root
    path_bar_element("Ingrédients", item_categories_path)
  end

  def path_bar_cart_lines_root
    path_bar_element("Panier", cart_lines_path)
  end

  def path_bar_session_root
    path_bar_element("Connection", new_user_session_path)
  end

end
