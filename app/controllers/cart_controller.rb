# Copyright (C) 2010, 2011 by Philippe Bourgau


# Controller for the shopping cart
# it stores the cart in the db, and its id in the session, so that
# the cart can be transferred from a domain to another
class CartController < ApplicationController

  before_filter :find_cart, :except => :forward_to_store
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
    cart = Cart.find_by_id(params[:cart_id].to_i)
    store = Store.find_by_id(params[:store_id].to_i)

    redirect_url = cart.forward_to(store, params[:store][:login], params[:store][:password])

    redirect_to redirect_url
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
  end

  def find_stores
    @stores = Store.find(:all)
  end

end
