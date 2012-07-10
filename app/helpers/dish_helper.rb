# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

module DishHelper
  include DisabledHelper

  def button_to_add_dish(dish)
    button_to 'Ajouter au panier', add_dish_to_cart_lines_path(dish), disabled_html_option_for(dish)
  end

end
