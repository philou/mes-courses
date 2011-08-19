# Copyright (C) 2010, 2011 by Philippe Bourgau

class DishesController < ApplicationController
  include PathBarHelper

  before_filter :assign_root_path_bar

  def index
    @dishes = Dish.find(:all)
  end

  def new
    self.path_bar.push(path_bar_element_for_current_resource("Nouvelle recette"))

    @dish = Dish.new(:name => "Nouvelle recette")
  end

  def create
    dish = Dish.create!(params[:dish])

    redirect_to :action => :show, :id => dish
  end

  def show
    @dish = Dish.find_by_id(params[:id])

    self.path_bar.push(path_bar_element_for_current_resource(@dish.name))
  end

  private

  def assign_root_path_bar
    self.path_bar = [path_bar_dishes_root]
  end

end
