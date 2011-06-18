# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemCategoryControllerStandaloneNesting
  include ActionController::UrlWriter

  def html_body_id
    'items'
  end

  def root_path_bar
    []
  end

  public :item_category_index_path, :item_category_path

  def add_item_label
    "Ajouter au panier"
  end
  def add_item_url_options
    {:controller => 'cart', :action => 'add_item'}
  end
  def add_item_html_options
    {:method => :get}
  end

  def show_sub_category_url_options
    {:controller => 'item_category', :action => 'show'}
  end
end
