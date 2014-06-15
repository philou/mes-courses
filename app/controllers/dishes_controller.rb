# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


class DishesController < ApplicationController
  include PathBarHelper

  before_filter :assign_root_path_bar, :assign_dish_modification_right

  def index
    @dishes = Dish.all
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

  def assign_dish_modification_right
    @can_modify_dishes = user_signed_in?
  end

end
