# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'models/invalid_store_account_error'

class OrdersController < ApplicationController
  include PathBarHelper

  protect_from_forgery :except => :create
  ssl_required :create

  def show
    self.path_bar = [path_bar_cart_lines_root, path_bar_element_with_no_link("Transfert")]
    @order = Order.find_by_id(params[:id].to_i)

    case @order.status
    when Order::FAILED
      flash[:notice] = @order.error_notice
      redirect_to :controller => 'cart_lines'

    when Order::SUCCEEDED
      render :template => 'orders/show_success'

    else
      @auto_refresh = true
      @forward_completion_percents = forward_completion_percents
      render :template => 'orders/show_passing'
    end
  end

  # Builds the session cart on an online store
  def create
    cart = Cart.find_by_id(params[:cart_id].to_i)
    @store = Store.find_by_id(params[:store_id].to_i)

    order = Order.create!(:store => @store, :cart => cart)
    order.delay.pass(params[:store][:login], params[:store][:password])

    redirect_to order_path(order)
  end

  private

  def forward_completion_percents
    if @order.cart.lines.empty?
      100
    else
      100 * @order.forwarded_cart_lines_count / @order.cart.lines.count
    end
  end

end
