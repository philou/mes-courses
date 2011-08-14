# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe OrdersController do

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

    it "should assign a @path_bar with two items" do
      get 'show', :id => @order.id

      assigns[:path_bar].should == [PathBar.element("Panier", :controller => 'cart_lines'),
                                    PathBar.element_with_no_link("Transfert")]
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

    it "should pass the order" do
      @order.should_receive(:pass).with(StoreCartAPI.valid_login, StoreCartAPI.valid_password)

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
