# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


class ItemCategoriesControllerDishNesting
  include Rails.application.routes.url_helpers
  include PathBarHelper

  def initialize(dish_id)
    @dish_id = dish_id
  end

  def root_path_bar
    dish = Dish.find_by_id(@dish_id)
    [path_bar_element("Recettes", dishes_path), path_bar_element(dish.name, dish_path(dish))]
  end

  def item_categories_path
    dish_item_categories_path(@dish_id)
  end

  def item_category_path(item_category)
    dish_item_category_path(@dish_id, item_category)
  end

  def add_item_label
    "Ajouter à la recette"
  end
  def add_item_url_options
    {:controller => 'items', :action => 'create', :dish_id => @dish_id}
  end
  def add_item_html_options
    {:method => :post}
  end

  def show_sub_category_url_options
    {:controller => 'item_categories', :action => 'show', :dish_id => @dish_id}
  end
end
