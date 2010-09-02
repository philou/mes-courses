# Copyright (C) 2010 by Philippe Bourgau

class DishController < ApplicationController

  def show
    @dishes = Dish.find(:all)
  end

end
