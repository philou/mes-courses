# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemCategoriesControllerStandaloneNesting
  include ActionController::UrlWriter

  def root_path_bar
    []
  end

  public :item_categories_path, :item_category_path

  def add_item_label
    "Ajouter au panier"
  end
  def add_item_url_options
    {:controller => 'cart_lines', :action => 'create'}
  end
  def add_item_html_options
    {:method => :post}
  end

  def show_sub_category_url_options
    {:controller => 'item_categories', :action => 'show'}
  end
end
