# Copyright (C) 2010, 2011 by Philippe Bourgau

class DishController < ApplicationController

  before_filter :assign_root_path_bar
  before_filter :assign_html_body_id

  def index
    @dishes = Dish.find(:all)
  end

  def new
    @path_bar.push(PathBar.element_for_current_resource("Nouvelle recette"))

    @dish = Dish.new(:name => "Nouvelle recette")
  end

  def create

    dish = Dish.create!(params[:dish])

    redirect_to :action => :show, :id => dish
  end

  def show
    @dish = Dish.find_by_id(params[:id])

    @path_bar.push(PathBar.element_for_current_resource(@dish.name))
  end

  private

  def assign_html_body_id
    @body_id = 'dish'
  end

  def assign_root_path_bar
    @path_bar = [PathBar.element('Recettes', :action => 'index')]
  end

end
