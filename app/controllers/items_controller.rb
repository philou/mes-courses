# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemsController < ApplicationController

  before_filter :find_dish_and_item
  after_filter :save_dish

  def create
    @dish.items.push(@item)
    redirect_to dish_path(@dish)
  end

  def destroy
    @dish.items.delete(@item)
    redirect_to dish_path(@dish)
  end

  private

  def find_dish_and_item
    @dish = Dish.find_by_id(params[:dish_id])
    @item = Item.find_by_id(params[:id])
  end

  def save_dish
    @dish.save!
  end

end
