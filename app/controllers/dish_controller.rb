# Copyright (C) 2010, 2011 by Philippe Bourgau

class DishController < ApplicationController

  def index
    raise RuntimeError.new("Page made to fail !")
    @dishes = Dish.find(:all)
  end

end
