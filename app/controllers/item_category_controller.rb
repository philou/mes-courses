# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemCategoryController < ApplicationController
  include ApplicationHelper

  def index
    # REFACTORING: create a root category, and simply redirect to show with this category ...
    @search_url = any_item_category_path

    if params.has_key?("search")
      keyword = params["search"]["keyword"]

      @title = "Résultats de la recherche pour \"#{keyword}\""
      @categories = []
      @items = Item.search_by_keyword_and_category(keyword)
    else
      @title = "Ingrédients"
      @categories = ItemCategory.find(:all, :conditions => {:parent_id => nil})
      @items = []
    end

    render :action => :show
  end

  def show
    item_category = ItemCategory.find_by_id(params[:id])
    @search_url = any_item_category_path(item_category)

    if (params.has_key?("search"))
      keyword = params["search"]["keyword"]
      @title = "Résultats de la recherche pour \"#{keyword}\" dans \"#{item_category.name}\""
      @categories = []
      @items = Item.search_by_keyword_and_category(keyword, item_category)
    else
      @title = item_category.name
      @categories = item_category.children
      @items = item_category.items
    end
  end

end
