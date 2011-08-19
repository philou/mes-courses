# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemCategoriesControllerDishNesting
  include ActionController::UrlWriter
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
