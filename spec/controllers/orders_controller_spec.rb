# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe OrdersController do
  include PathBarHelper

  ignore_user_authentication

  before(:each) do
    @cart = stub_model(Cart)

    @store = stub_model(Store, :url => "http://www.mega-store.com")
  end

  context "displaying an order" do

    before :each do
      @order = stub_model(Order, :cart => @cart, :store => @store)
      Order.stub(:find_by_id).with(@order.id).and_return(@order)
    end

    context "redirections" do

      ['logout', 'login'].each do |action|
        it "#{action} should redirect to show when the order is not yet passed" do
          get_with_status(action, :whatever_but_succeeded)

          response.should redirect_to(action: 'show')
        end
      end
      it "should render show template when the order is not yet being passed" do
        get_with_status('show', Order::NOT_PASSED)

        response.should render_template('orders/show')
      end

      it "show should redirect passed orders to logout" do
        get_with_status('show', Order::SUCCEEDED)

        response.should redirect_to(action: 'logout')
      end

    end

    context "when an order transfer failed" do

      before :each do
        @error_notice = "Login failed"
        @order.stub(:error_notice).and_return(@error_notice)
        @order.stub(:status).and_return(Order::FAILED)
      end

      it "should redirect to cart" do
        get 'show', :id => @order.id

        response.should redirect_to(:controller => 'cart_lines')
      end

      it "should set a flash message" do
        get 'show', :id => @order.id

        flash[:notice].should == @error_notice
      end
    end

    def self.it_should_assign_a_path_bar_with_2_items(action, order_status)
      it "#{action} should assign a @path_bar with two items" do
        get_with_status(action, order_status)

        assigns(:path_bar).should == [path_bar_cart_lines_root,
                                        path_bar_element_with_no_link("Transfert")]
      end
    end

    def self.it_should_assign_an_order(action, order_status)
      it "#{action} should assign an order" do
        get_with_status(action, order_status)

        assigns(:order).should == @order
      end
    end

    def self.it_should_render_corresponding_template(action, order_status)
      it "#{action} with #{order_status} order should render #{action} template" do
        get_with_status(action, order_status)

        response.should render_template("orders/#{action}")
      end
    end
    def self.it_should_assign_forward_completion_percents(action, order_status)
      it "#{action} with #{order_status} order should assign a forward_completion_percents" do
        @order.stub(:passed_ratio).and_return(0.2543)

        get_with_status(action, order_status)

        assigns(:forward_completion_percents).should == 25
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

      assigns(:refresh_strategy).should == MesCourses::HtmlUtils::PageRefreshStrategy.new
    end

    it "login should automaticaly redirect to logout" do
      get_with_status('logout', Order::SUCCEEDED)

      assigns(:refresh_strategy).should == MesCourses::HtmlUtils::PageRefreshStrategy.new(interval: OrdersController::LOGOUT_ALLOWED_SECONDS, url: order_login_path(@order))
    end

    it "login should assign login and password" do
      session[:login] = login = "a login"
      session[:password] = password = "a password"

      get_with_status('login', Order::SUCCEEDED)

      assigns[:login].should == login
      assigns[:password].should == password
    end

    def get_with_status(action, order_status)
      @order.stub(:status).and_return(order_status)

      get action, :id => @order.id
    end
  end

  context "forwarding to a store" do

    before(:each) do
      @missing_items_notices = []
      Cart.stub(:find_by_id).with(@cart.id).and_return(@cart)
      Store.stub(:find_by_id).with(@store.id).and_return(@store)

      @order = stub_model(Order)
      Order.stub(:create!).and_return(@order)
      @order.stub(:pass) do |login, password|
        @order.forwarded_cart_lines_count = @cart.lines.size
        @order.stub(:warning_notices).and_return(@missing_items_notices)
      end
    end

    it "should create an order with cart and store" do
      Order.should_receive(:create!).with({ :cart => @cart, :store => @store })

      forward_to_valid_store_account
    end

    it "should asynchronously pass the order" do
      delayed_job = stub("Delayed_job")
      @order.should_receive(:delay).and_return(delayed_job)
      delayed_job.should_receive(:pass).with(MesCourses::Stores::Carts::Api.valid_login, MesCourses::Stores::Carts::Api.valid_password)

      forward_to_valid_store_account
    end

    it "should redirect to the created order" do
      forward_to_valid_store_account

      response.should redirect_to(order_path(@order))
    end

    it "should store the login and password to the session" do
      forward_to_valid_store_account

      session[:login].should == @login
      session[:password].should == @password
    end

    def forward_to_valid_store_account
      post 'create', :store_id => @store.id, :cart_id => @cart.id, :store => {:login => @login = MesCourses::Stores::Carts::Api.valid_login, :password => @password = MesCourses::Stores::Carts::Api.valid_password}
    end

  end

end
