# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe OrdersController do
  include PathBarHelper

  ignore_user_authentication

  before(:each) do
    @cart = FactoryGirl.create(:cart)
    @store = FactoryGirl.create(:store)
  end

  context "displaying an order" do

    before :each do
      @order = FactoryGirl.create(:order, :cart => @cart, :store => @store)
      session[:store_credentials] = @credentials = FactoryGirl.build(:credentials)
    end

    context "redirections" do

      ['logout', 'login'].each do |action|
        it "#{action} should redirect to show when the order is not yet passed" do
          get_with_status(action, :whatever_but_succeeded)

          expect(response).to redirect_to(action: 'show')
        end
      end
      it "should render show template when the order is not yet being passed" do
        get_with_status('show', Order::NOT_PASSED)

        expect(response).to render_template('orders/show')
      end

      it "show should redirect passed orders to logout" do
        get_with_status('show', Order::SUCCEEDED)

        expect(response).to redirect_to(action: 'logout')
      end

    end

    context "when an order transfer failed" do

      before :each do
        @order.update_attribute(:error_notice, "Login failed")
        @order.update_attribute(:status, Order::FAILED)
      end

      it "should redirect to cart" do
        get 'show', :id => @order.id

        expect(response).to redirect_to(:controller => 'cart_lines')
      end

      it "should set a flash message" do
        get 'show', :id => @order.id

        expect(flash[:alert]).to eq @order.error_notice
      end
    end

    def self.it_should_assign_a_path_bar_with_2_items(action, order_status)
      it "#{action} should assign a @path_bar with two items" do
        get_with_status(action, order_status)

        expect(assigns(:path_bar)).to eq [path_bar_cart_lines_root,
                                      path_bar_element_with_no_link("Transfert")]
      end
    end

    def self.it_should_assign_an_order(action, order_status)
      it "#{action} should assign an order" do
        get_with_status(action, order_status)

        expect(assigns(:order)).to eq @order
      end
    end

    def self.it_should_render_corresponding_template(action, order_status)
      it "#{action} with #{order_status} order should render #{action} template" do
        get_with_status(action, order_status)

        expect(response).to render_template("orders/#{action}")
      end
    end
    def self.it_should_assign_forward_completion_percents(action, order_status)
      it "#{action} with #{order_status} order should assign a forward_completion_percents" do
        Order.proxy_chain(:find_by_id, :passed_ratio) {|s| s.and_return(0.2543) }

        get_with_status(action, order_status)

        expect(assigns(:forward_completion_percents)).to eq 25
      end
    end

    SHOW = ['show', Order::PASSING]
    LOGOUT = ['logout', Order::SUCCEEDED]
    LOGIN = ['login', Order::SUCCEEDED]

    [SHOW, LOGOUT, LOGIN].each do |action_and_status|
      it_should_assign_a_path_bar_with_2_items(*action_and_status)
      it_should_assign_an_order(*action_and_status)
      it_should_render_corresponding_template(*action_and_status)
    end

    [SHOW, LOGOUT].each do |action_and_status|
      it_should_assign_forward_completion_percents(*action_and_status)
    end

    it "show with passing order asks the page to auto refresh" do
      get_with_status('show', Order::PASSING)

      expect(assigns(:refresh_strategy)).to eq MesCourses::HtmlUtils::PageRefreshStrategy.new
    end

    it "login should automaticaly redirect to logout" do
      get_with_status('logout', Order::SUCCEEDED)

      expect(assigns(:refresh_strategy)).to eq MesCourses::HtmlUtils::PageRefreshStrategy.new(interval: OrdersController::LOGOUT_ALLOWED_SECONDS, url: order_login_path(@order))
    end

    it "login should assign store login parameters" do
      get_with_status('login', Order::SUCCEEDED)

      expect(assigns[:store_login_parameters]).to eq(MesCourses::Stores::Carts::DummyApi.login_parameters(@credentials.login, @credentials.password))
    end

    it "redirects to the cart if the login fails" do
      MesCourses::Stores::Carts::DummyApi.stub(:login_parameters).and_raise(SocketError.new)

      get_with_status('login', Order::SUCCEEDED)

      expect(response).to redirect_to(:controller => 'cart_lines')
      expect(flash[:alert]).to eq(Order.invalid_store_login_notice(@order.store_name))
    end

    def get_with_status(action, order_status)
      @order.update_attribute(:status, order_status)

      get action, :id => @order.id
    end
  end

  context "forwarding to a store" do

    before(:each) do
      @credentials = FactoryGirl.build(:valid_credentials)
    end

    it "should create an order with cart and store" do
      capture_result_from(Order, :create!, into: :order)

      forward_to_valid_store_account

      expect(@order).not_to be_nil
      expect(@order.cart).to eq @cart
      expect(@order.store).to eq @store
    end

    it "should pass the order" do
      Order.on_result_from(:create!) {|order| order.skip_delay}
      capture_result_from(MesCourses::Stores::Carts::DummyApi, :login, into: :dummy_api)

      forward_to_valid_store_account

      expect(@dummy_api).to have_received_order(@cart, @credentials)
    end

    it "should pass the order asynchronously, later" do
      MesCourses::Stores::Carts::DummyApi.should_not_receive(:login)

      forward_to_valid_store_account
    end

    it "should redirect to the created order" do
      capture_result_from(Order, :create!, into: :order)

      forward_to_valid_store_account

      expect(response).to redirect_to(order_path(@order))
    end

    it "should store the login and password to the session" do
      forward_to_valid_store_account

      expect(session[:store_credentials]).to eq @credentials
    end

    def forward_to_valid_store_account
      post 'create', :store_id => @store.id, :cart_id => @cart.id, :store => {:login => @credentials.login, :password => @credentials.password}
    end

  end

end
