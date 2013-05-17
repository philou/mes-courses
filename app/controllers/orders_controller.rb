# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

class OrdersController < ApplicationController
  include PathBarHelper

  LOGOUT_ALLOWED_SECONDS = 10

  before_filter :assign_path_bar, except: :create
  before_filter :assign_order, except: :create
  before_filter :assign_completion_percents, only: [:show, :logout]

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

    @refresh_strategy = MesCourses::HtmlUtils::PageRefreshStrategy.new
  end

  def logout
    return if unsuccessful_order_redirected_to_show

    @refresh_strategy = MesCourses::HtmlUtils::PageRefreshStrategy.new(interval: LOGOUT_ALLOWED_SECONDS, url: order_login_path(@order))
  end

  def login
    return if unsuccessful_order_redirected_to_show
  end

  private

  def assign_path_bar
    self.path_bar = [path_bar_cart_lines_root, path_bar_element_with_no_link("Transfert")]
  end
  def assign_order
    @order = Order.find_by_id(params[:id].to_i)
  end

  def assign_completion_percents
    @forward_completion_percents = forward_completion_percents
  end

  def unsuccessful_order_redirected_to_show
    if @order.status != Order::SUCCEEDED
      redirect_to action: 'show'
      true
    else
      false
    end
  end

  def forward_completion_percents
    (@order.passed_ratio * 100).to_i
  end

end
