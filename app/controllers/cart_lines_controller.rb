# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

# Controller for the shopping cart
# it stores the cart in the db, and its id in the session, so that
# the cart can be transferred from a domain to another
class CartLinesController < ApplicationController
  include ApplicationHelper

  before_filter :find_cart
  before_filter :find_stores

  # Displays the full session's cart
  def index
    self.path_bar = [path_bar_cart_lines_root]
  end

  # adds the item with params[:id] to the cart
  def create
    item = add_to_cart(Item)
    flash[:notice] = "\"#{item.long_name}\" a été ajouté à votre panier"

    Rails.logger.debug flash[:notice]

    redirect_to root_item_category_path
  end

  # adds the whole dish with params[:id] to the cart
  def add_dish
    dish = add_to_cart(Dish)
    flash[:notice] = "\"#{dish.name}\" a été ajouté à votre panier"

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

end
