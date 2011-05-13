# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemCategoryController < ApplicationController
  include ApplicationHelper

  before_filter :assign_html_body_id

  def index
    # REFACTORING: create a root category, and simply redirect to show with this category ...
    @search_url = any_item_category_path

    if params.has_key?("search")
      keyword = params["search"]["keyword"]

      @path_bar = search_path_bar(keyword)
      @categories = []
      @items = Item.search_by_keyword_and_category(keyword)

    else
      @path_bar = path_bar
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
      @path_bar = search_path_bar(keyword, item_category)
      @categories = []
      @items = Item.search_by_keyword_and_category(keyword, item_category)

    else
      @path_bar = path_bar(item_category)
      @categories = item_category.children
      @items = item_category.items
    end
  end

  private

  def assign_html_body_id
    @body_id = 'items'
  end

  def search_path_bar(keyword, item_category = nil)
    result = path_bar(item_category)
    result.push(PathBar.element_with_no_link(keyword))
    result
  end

  def path_bar(item_category = nil)
    collect_path_bar(item_category)
  end

  def collect_path_bar(item_category, result = [])
    if item_category.nil?
      result.push PathBar.element("Ingrédients", :controller => 'item_category')
    else
      collect_path_bar(item_category.parent, result)
      result.push PathBar.element(item_category.name, item_category_path(item_category))
    end

    result
  end

end
