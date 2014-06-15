# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
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


# Controller for the shopping cart
# it stores the cart in the db, and its id in the session, so that
# the cart can be transferred from a domain to another
class CartLinesController < ApplicationController
  include ApplicationHelper

  before_filter :find_cart
  before_filter :find_stores

  BUYING_CONFIRMATION_NOTICE = 'a été ajouté à votre panier'

  def self.buying_confirmation_notice(name)
    "\"#{name}\" #{BUYING_CONFIRMATION_NOTICE}"
  end

  # Displays the full session's cart
  def index
    self.path_bar = [path_bar_cart_lines_root]
  end

  # adds the item with params[:id] to the cart
  def create
    item = add_to_cart(Item)

    confirm_buying(item.long_name)
    redirect_to root_item_category_path
  end

  # adds the whole dish with params[:id] to the cart
  def add_dish
    dish = add_to_cart(Dish)

    confirm_buying(dish.name)
    redirect_to dishes_path
  end

  # empties the current cart
  def destroy_all
    @cart.empty
    @cart.save!
    redirect_to :action => :index
  end

  private

  def find_cart
    cart_id = session[:cart_id]
    @cart = Cart.find_by_id(cart_id) unless cart_id.nil?
    if @cart.nil?
      @cart = Cart.create
      session[:cart_id] = @cart.id
    end
  end

  def add_to_cart(model)
    thing = model.find(params[:id])
    @cart.send("add_#{model.to_s.downcase}".intern, thing)
    @cart.save!
    thing
  end

  def find_stores
    @stores = Store.all
  end

  def confirm_buying(name)
    flash[:notice] = self.class.buying_confirmation_notice(name)
  end

end
