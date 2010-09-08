# Copyright (C) 2010 by Philippe Bourgau

class DishController < ApplicationController

  def index
    @dishes = Dish.find(:all)
  end

end
