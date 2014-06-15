# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau
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


require 'spec_helper'

describe CartLinesController do
  include ApplicationHelper

  ignore_user_authentication

  before(:each) do
    capture_result_from(Cart, :create, into: :cart)
  end

  context "session handling" do

    before :each do
      @item = FactoryGirl.create(:item)
      @dish = FactoryGirl.create(:dish)
    end

    def self.it_should_find_or_create_a_session_when_answering (action, &request)
      context "when answering #{action}" do

        it "should create a new cart in session if no one exists" do
          http(&request)

          expect(session[:cart_id]).to eq @cart.id
        end

        it "should reuse existing cart from session if one exists" do
          session[:cart_id] = FactoryGirl.create(:cart).id

          expect { http(&request) }.not_to change { carts_ids }
        end

        def http(&request)
          instance_eval(&request)
        end

        def carts_ids
          Cart.all.map &:id
        end
      end
    end

    it_should_find_or_create_a_session_when_answering(:index) { get :index }
    it_should_find_or_create_a_session_when_answering(:destroy_all) { delete :destroy_all}
    it_should_find_or_create_a_session_when_answering(:create) { post :create, id: @item.id}
    it_should_find_or_create_a_session_when_answering(:add_dish) { post :add_dish, id: @dish.id }

  end


  it "should assign a path_bar with index" do
    get :index

    expect(assigns(:path_bar)).to eq [path_bar_cart_lines_root]
  end

  it "should assign a cart with index" do
    get :index

    expect(assigns(:cart)).to eq @cart
  end

  it "should assign stores with index" do
    store = FactoryGirl.create(:store)

    get :index

    expect(assigns(:stores)).to eq [store]
  end

  # The 3 following contexts look a lot like each other, there were factored out before, but it was unreadable ...

  context "when destroying the cart" do

    before :each do
      @cart = FactoryGirl.create(:cart, :with_items)
      session[:cart_id] = @cart.id
    end

    it "should empty the session cart" do
      delete :destroy_all

      @cart.reload
      expect(@cart).to be_empty
    end

    it "should redirect to show" do
      delete :destroy_all

      expect(response).to redirect_to(:action => 'index')
    end
  end

  context "when adding item to cart" do

    before(:each) do
      @item = FactoryGirl.create(:item)
    end

    it "adds a line to the cart" do
      post_add_item

      @cart.reload
      expect(@cart.lines.map &:item).to include(@item)
    end

    it "redirects to items" do
      post_add_item

      expect(response).to redirect_to(root_item_category_path)
    end

    it "displays a buying confirmation notice" do
      post_add_item

      expect(flash[:notice]).to eq CartLinesController.buying_confirmation_notice(@item.long_name)
    end

    def post_add_item
      post :create, :id => @item.id
    end
  end

  context "when adding dish to cart" do

    before(:each) do
      @dish = FactoryGirl.create(:dish)
    end

    it "adds a dish to the cart" do
      post_add_dish

      @cart.reload
      expect(@cart.dishes).to include(@dish)
    end

    it "should redirect to products" do
      post_add_dish

      expect(response).to redirect_to(:controller => 'dishes')
    end

    it "displays a buying confirmation notice" do
      post_add_dish

      expect(flash[:notice]).to eq CartLinesController.buying_confirmation_notice(@dish.name)
    end

    def post_add_dish
      post :add_dish, :id => @dish.id
    end
  end

end
