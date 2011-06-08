# Copyright (C) 2010, 2011 by Philippe Bourgau

class ItemsController < ApplicationController

  def create
    dish = Dish.find_by_id(params[:dish_id])
    item = Item.find_by_id(params[:id])

    dish.items.push(item)
    dish.save!

    redirect_to dish_path(dish)
  end

end
