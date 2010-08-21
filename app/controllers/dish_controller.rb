class DishController < ApplicationController

  def show
    @dishes = Dish.find(:all)
  end

end
