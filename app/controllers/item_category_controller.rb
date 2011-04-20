# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemCategoryController < ApplicationController

  def index
    @item_category = ItemCategory.new(:name => "Ingrédients")
    @item_category.children = ItemCategory.find(:all, :conditions => {:parent_id => nil})
    render :action => :show
  end

  def show
    @item_category = ItemCategory.find_by_id(params[:id])
  end

end
