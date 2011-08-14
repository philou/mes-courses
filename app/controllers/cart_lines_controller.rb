# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'models/invalid_store_account_error'

# Controller for the shopping cart
# it stores the cart in the db, and its id in the session, so that
# the cart can be transferred from a domain to another
class CartLinesController < ApplicationController

  before_filter :assign_html_body_id
  before_filter :find_cart
  before_filter :find_stores

  # Displays the full session's cart
  def index
    @path_bar = [PathBar.element_for_current_resource("Panier")]
  end

  # adds the item with params[:id] to the cart
  def create
    add_to_cart(Item)
    redirect_to :controller => 'item_categories'
  end

  # adds the whole dish with params[:id] to the cart
  def add_dish
    add_to_cart(Dish)
    redirect_to :controller => 'dishes'
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
  end

  def find_stores
    @stores = Store.find(:all)
  end

  def assign_html_body_id
    @body_id = 'cart'
  end
end
