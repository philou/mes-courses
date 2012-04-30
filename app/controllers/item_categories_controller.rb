# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemCategoriesController < ApplicationController
  include ApplicationHelper

  before_filter :assign_nesting

  def index
    redirect_to @nesting.item_category_path(ItemCategory.root)
  end

  def show
    assign_show_sub_category_url_options
    assign_add_item_attributes

    item_category = ItemCategory.find_by_id(params[:id])
    @search_url = @nesting.item_category_path(item_category)

    if (params.has_key?("search"))
      search_string = params["search"]["search_string"]
      self.path_bar = search_path_bar(search_string, item_category)
      @categories = []
      @items = Item.search_by_string_and_category(search_string, item_category)

    else
      self.path_bar = path_bar(item_category)
      @categories = item_category.children
      @items = item_category.items
    end
  end

  private

  def assign_add_item_attributes
    @add_item_label = @nesting.add_item_label
    @add_item_url_options = @nesting.add_item_url_options
    @add_item_html_options = @nesting.add_item_html_options
  end

  def assign_show_sub_category_url_options
    @show_sub_category_url_options = @nesting.show_sub_category_url_options
  end

  def search_path_bar(search_string, item_category = nil)
    result = path_bar(item_category)
    result.push(path_bar_element_with_no_link(search_string))
    result
  end

  def path_bar(item_category = nil)
    result = @nesting.root_path_bar

    collect_path_bar(item_category, result)

    result
  end

  def collect_path_bar(item_category, result)
    if item_category.nil? || item_category.root?
      result.push path_bar_element("Ingrédients", @nesting.item_categories_path)
    else
      collect_path_bar(item_category.parent, result)
      result.push path_bar_element(item_category.name, @nesting.item_category_path(item_category))
    end
  end

  def assign_nesting
    @nesting = new_nesting
  end
  def new_nesting
    if params[:dish_id].nil?
      ItemCategoriesControllerStandaloneNesting.new
    else
      ItemCategoriesControllerDishNesting.new(params[:dish_id])
    end
  end


end
