# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau
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
