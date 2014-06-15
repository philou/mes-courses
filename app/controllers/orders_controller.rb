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


class OrdersController < ApplicationController
  include PathBarHelper

  LOGOUT_ALLOWED_SECONDS = 10

  before_filter :assign_path_bar, except: :create
  before_filter :assign_order, except: :create
  before_filter :assign_completion_percents, only: [:show, :logout]

  # Builds the session cart on an online store
  def create
    @order = Order.create!(:store => find_store, :cart => find_cart)

    session[:store_credentials] = credentials = find_credentials
    @order.delay.pass(credentials)

    respond_to do |format|
      format.html { redirect_to order_path(@order) }
      format.json { render json: {redirect: order_path(@order)} }
    end
  end

  def show
    case @order.status
    when Order::FAILED
      flash[:alert] = @order.error_notice
      redirect_to controller: 'cart_lines'
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

    begin
      store_credentials = session[:store_credentials]
      @store_login_parameters = @order.store_login_parameters(store_credentials)
    rescue
      flash[:alert] = Order.invalid_store_login_notice(@order.store_name)
      redirect_to controller: 'cart_lines'
    end
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

  def find_cart
    Cart.find_by_id(params[:cart_id].to_i)
  end
  def find_store
    Store.find_by_id(params[:store_id].to_i)
  end
  def find_credentials
    MesCourses::Utils::Credentials.new(params[@order.store_login_parameter],params[@order.store_password_parameter])
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
