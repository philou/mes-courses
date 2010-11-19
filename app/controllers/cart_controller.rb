# Copyright (C) 2010 by Philippe Bourgau


# Controller for the shopping cart
class CartController < ApplicationController

  before_filter :find_cart

  # Displays the full session's cart
  def show
  end

  # adds the item with params[:id] to the cart
  def add_item_to_cart
    add_to_cart(Item)
    redirect_to :controller => 'item_category'
  end

  # adds the whole dish with params[:id] to the cart
  def add_dish_to_cart
    add_to_cart(Dish)
    redirect_to :controller => 'dish'
  end

  private

  def find_cart
    @cart = session[:cart] ||= Cart.new
  end

  def add_to_cart(model)
    thing = model.find(params[:id])
    @cart.send("add_#{model.to_s.downcase}".intern, thing)
  end

end
