# Copyright (C) 2010, 2011 by Philippe Bourgau

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
      @remote_store_order_url = "http://www.mega-store.com/logout"
      @order = stub_model(Order, :cart => @cart, :store => @store, :remote_store_order_url => @remote_store_order_url)
      Order.stub(:find_by_id).with(@order.id).and_return(@order)
    end

    it "should render template show_success when the order is passed" do
      @order.stub(:status).and_return(Order::SUCCEEDED)

      get 'show', :id => @order.id

      response.should render_template('orders/show_success')
    end

    it "should assign a @path_bar with two items" do
      get 'show', :id => @order.id

      assigns[:path_bar].should == [path_bar_cart_lines_root,
                                    path_bar_element_with_no_link("Transfert")]
    end

    it "should assign an order to the view" do
      get 'show', :id => @order.id

      assigns[:order].should == @order
    end

    context "using an invalid store account" do

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

    it "should render show_passing template when the order is not yet being passed" do
      @order.stub(:status).and_return(Order::NOT_PASSED)

      get 'show', :id => @order.id

      response.should render_template('orders/show_passing')
    end

    context "when the order is being passed" do

      before :each do
        @order.stub(:status).and_return(Order::PASSING)
      end

      it "should render show_passing template" do
        get 'show', :id => @order.id

        response.should render_template('orders/show_passing')
      end

      it "should assign a forward_completion_ratio" do
        @order.stub(:forwarded_cart_lines_count).and_return(4)
        @cart.stub(:lines).and_return(Array.new(7, stub_model(CartLine)))

        get 'show', :id => @order.id

        assigns[:forward_completion_percents].should == 100 * 4 / 7
      end

      it "should ask to page to auto refresh" do
        get 'show', :id => @order.id

        assigns[:auto_refresh].should be_true
      end
    end
  end

  context "forwarding to a store" do

    before(:each) do
      @logout_url = "#{@store.url}/deconnexion"
      @missing_items_notices = []
      Cart.stub(:find_by_id).with(@cart.id).and_return(@cart)
      Store.stub(:find_by_id).with(@store.id).and_return(@store)

      @order = stub_model(Order)
      Order.stub(:create!).and_return(@order)
      @order.stub(:pass) do |login, password|
        @order.forwarded_cart_lines_count = @cart.lines.size
        @order.stub(:warning_notices).and_return(@missing_items_notices)
        @order.remote_store_order_url = @logout_url
      end
    end

    it "should create an order with cart and store" do
      Order.should_receive(:create!).with({ :cart => @cart, :store => @store })

      forward_to_valid_store_account
    end

    it "should asynchronously pass the order" do
      delayed_job = stub("Delayed_job")
      @order.should_receive(:delay).and_return(delayed_job)
      delayed_job.should_receive(:pass).with(StoreCartAPI.valid_login, StoreCartAPI.valid_password)

      forward_to_valid_store_account
    end

    it "should redirect to the created order" do
      forward_to_valid_store_account

      response.should redirect_to(order_path(@order))
    end

    def forward_to_valid_store_account
      post 'create', :store_id => @store.id, :cart_id => @cart.id, :store => {:login => StoreCartAPI.valid_login, :password => StoreCartAPI.valid_password}
    end

  end

end
