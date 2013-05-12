# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

class OrdersController < ApplicationController
  include PathBarHelper

  before_filter :setup_path_bar_and_order, only: [:show, :logout]

  # not sure this is required anymore
  protect_from_forgery :except => :create

  # Builds the session cart on an online store
  def create
    cart = Cart.find_by_id(params[:cart_id].to_i)
    @store = Store.find_by_id(params[:store_id].to_i)

    order = Order.create!(:store => @store, :cart => cart)
    order.delay.pass(params[:store][:login], params[:store][:password])

    redirect_to order_path(order)
  end

  def show
    case @order.status
    when Order::FAILED
      flash[:notice] = @order.error_notice
      redirect_to :controller => 'cart_lines'
      return

    when Order::SUCCEEDED
      redirect_to action: 'logout'
      return

    end

    @auto_refresh = true
    @forward_completion_percents = forward_completion_percents
  end

  def logout
    if @order.status != Order::SUCCEEDED
      redirect_to action: 'show'
      return
    end
  end

  private

  def setup_path_bar_and_order
    self.path_bar = [path_bar_cart_lines_root, path_bar_element_with_no_link("Transfert")]
    @order = Order.find_by_id(params[:id].to_i)
  end

  def forward_completion_percents
    (@order.passed_ratio * 100).to_i
  end

end
