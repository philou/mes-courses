# Copyright (C) 2010, 2011 by Philippe Bourgau


# Controller for the shopping cart
class CartController < ApplicationController

  before_filter :find_cart
  before_filter :find_stores

  protect_from_forgery :except => :forward_to_store

  # Displays the full session's cart
  def show
  end

  # adds the item with params[:id] to the cart
  def add_item
    add_to_cart(Item)
    redirect_to :controller => 'item_category'
  end

  # adds the whole dish with params[:id] to the cart
  def add_dish
    add_to_cart(Dish)
    redirect_to :controller => 'dish'
  end

  # Builds the session cart on an online store
  def forward_to_store
    store = Store.find_by_id(params[:id])

    redirect_url = @cart.forward_to(store, params[:store][:login], params[:store][:password])

    redirect_to redirect_url
  end

  private

  def find_cart
    @cart = session[:cart]
    if @cart
      Rails.logger.info("Found session cart with '#{@cart.lines.inspect}'")
    else
      Rails.logger.warn("Creating a new session cart")
      @cart = session[:cart] = Cart.new
    end
  end

  def add_to_cart(model)
    thing = model.find(params[:id])
    @cart.send("add_#{model.to_s.downcase}".intern, thing)
  end

  def find_stores
    @stores = Store.find(:all)
  end

end
