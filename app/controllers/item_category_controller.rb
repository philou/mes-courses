# Copyright (C) 2010 by Philippe Bourgau

class ItemCategoryController < ApplicationController

  def index
    @item_categories = ItemCategory.find(:all, :conditions => {:parent_id => nil})
  end

  def show
    @item_category = ItemCategory.find_by_id(params[:id])
  end

end
