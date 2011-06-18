# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemCategoryController < ApplicationController
  include ApplicationHelper

  before_filter :assign_nesting
  before_filter :assign_html_body_id
  before_filter :assign_show_sub_category_url_options
  before_filter :assign_add_item_attributes

  def index
    # REFACTORING: create a root category, and simply redirect to show with this category ...
    @search_url = @nesting.item_category_index_path

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
    @search_url = @nesting.item_category_path(item_category)

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
    @body_id = @nesting.html_body_id
  end

  def assign_add_item_attributes
    @add_item_label = @nesting.add_item_label
    @add_item_url_options = @nesting.add_item_url_options
    @add_item_html_options = @nesting.add_item_html_options
  end

  def assign_show_sub_category_url_options
    @show_sub_category_url_options = @nesting.show_sub_category_url_options
  end

  def search_path_bar(keyword, item_category = nil)
    result = path_bar(item_category)
    result.push(PathBar.element_with_no_link(keyword))
    result
  end

  def path_bar(item_category = nil)
    result = @nesting.root_path_bar

    collect_path_bar(item_category, result)

    result
  end

  def collect_path_bar(item_category, result)
    if item_category.nil?
      result.push PathBar.element("Ingrédients", @nesting.item_category_index_path)
    else
      collect_path_bar(item_category.parent, result)
      result.push PathBar.element(item_category.name, @nesting.item_category_path(item_category))
    end
  end

  def assign_nesting
    @nesting = new_nesting
  end
  def new_nesting
    if params[:dish_id].nil?
      ItemCategoryControllerStandaloneNesting.new
    else
      ItemCategoryControllerDishNesting.new(params[:dish_id])
    end
  end


end
