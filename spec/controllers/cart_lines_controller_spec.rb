# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe CartLinesController do

  before(:each) do
    @cart = stub_model(Cart)
    @cart.stub(:save!)
    @cart.stub(:add_dish)
    Cart.stub(:create).and_return(@cart)

    @store = stub_model(Store, :url => "http://www.mega-store.com")
    @stores = [@store]
    Store.stub(:find).and_return(@stores)
    Store.stub(:find_by_id).with(@store.id).and_return(@store)
  end

  context "session handling" do

    before :each do
      Item.stub(:find).and_return(stub_model(Item))
      Dish.stub(:find).and_return(stub_model(Dish))
    end

    # for every action
    [[:get, :index],
     [:delete, :destroy_all],
     [:post, :create],
     [:post, :add_dish]].each do |method, action|

      context "when answering #{action}" do

        it "should create a new cart in session if no one exists" do
          send(method, action)

          session[:cart_id].should == @cart.id
        end

        it "should reuse existing cart from session if one exists" do
          session[:cart_id] = @cart.id
          Cart.stub(:find_by_id).with(@cart.id).and_return(@cart)

          Cart.should_not_receive(:create)

          send(method, action)
        end

      end

    end

  end


  it "should assign a path_bar with index" do
    get :index

    assigns[:path_bar].should == [PathBar.element_for_current_resource("Panier")]
  end

  it "should assign a cart with index" do
    get :index

    assigns[:cart].should be @cart
  end

  it "should assign stores with index" do
    get :index

    assigns[:stores].should be @stores
  end

  # The 3 following contexts look a lot like each other, there were factored out before, but it was unreadable ...

  context "when destroying the cart" do

    it "should empty the session cart" do
      @cart.should_receive(:empty)

      delete :destroy_all
    end

    it "should save the modified cart" do
      @cart.should_receive(:save!)

      delete :destroy_all
    end

    it "should redirect to show" do
      delete :destroy_all

      response.should redirect_to(:action => 'index')
    end
  end

  context "when adding item to cart" do

    before(:each) do
      @item = stub_model(Item)
      Item.stub!(:find).and_return(@item)
    end

    it "should delegate to the cart" do
      @cart.should_receive(:add_item).with(@item)

      post_add_item
    end

    it "should save the modified cart" do
      @cart.should_receive(:save!)

      post_add_item
    end

    it "should redirect to items" do
      post_add_item

      response.should redirect_to(:controller => 'item_categories')
    end

    def post_add_item
      post :create, :id => @item.id
    end
  end

  context "when adding dish to cart" do

    before(:each) do
      @dish = stub_model(Dish)
      Dish.stub!(:find).and_return(@dish)
    end

    it "should delegate to the cart" do
      @cart.should_receive(:add_dish).with(@dish)

      post_add_dish
    end

    it "should save the modified cart" do
      @cart.should_receive(:save!)

      post_add_dish
    end

    it "should redirect to products" do
      post_add_dish

      response.should redirect_to(:controller => 'dishes')
    end

    def post_add_dish
      post :add_dish, :id => @dish.id
    end
  end

  context "forwarding to a store" do

    before(:each) do
      @logout_url = "#{@store.url}/deconnexion"
      @missing_items_notices = []
      @forward_cart = stub_model(Cart)
      Cart.stub(:find_by_id).with(@forward_cart.id).and_return(@forward_cart)

      @order = stub_model(Order)
      Order.stub(:create!).and_return(@order)
      @order.stub(:pass) do |login, password|
        @order.forwarded_cart_lines_count = @forward_cart.lines.size
        @order.stub(:warning_notices).and_return(@missing_items_notices)
        @order.remote_store_order_url = @logout_url
      end
    end

    it "should assign a @path_bar with two items" do
      forward_to_valid_store_account

      assigns[:path_bar].should == [PathBar.element("Panier", :controller => 'cart_lines'),
                                    PathBar.element_with_no_link("Transfert")]
    end

    it "should create an order with cart and store" do
      Order.should_receive(:create!).with({ :cart => @forward_cart, :store => @store })

      forward_to_valid_store_account
    end

    it "should pass the order" do
      @order.should_receive(:pass).with(StoreCartAPI.valid_login, StoreCartAPI.valid_password)

      forward_to_valid_store_account
    end

    it "should populate a forward report page" do
      forward_to_valid_store_account

      assigns[:store].should == @store
      assigns[:remote_store_order_url].should == @logout_url
      assigns[:forward_notices].should_not be_nil
    end

    it "should fill forward notices with missing items" do
      @missing_items_notices = ["Langue de Boeuf","Cervelle d'agneau"]

      forward_to_valid_store_account

      assigns[:forward_notices].should == @missing_items_notices
    end

    context "using an invalid store account" do

      before :each do
        @error_notice = "Login failed"
        @order.stub(:pass) do |login, password|
          @order.stub(:status).and_return(Order::FAILED)
          @order.stub(:error_notice).and_return(@error_notice)
        end
        post 'forward_to_store', :store_id => @store.id, :cart_id => @forward_cart.id, :store => {:login => StoreCartAPI.invalid_login, :password => StoreCartAPI.invalid_password}
      end

      it "should redirect to cart" do
        response.should redirect_to(:controller => 'cart_lines')
      end

      it "should set a flash message" do
        flash[:notice].should_not be_blank
      end
    end

    def forward_to_valid_store_account
      post 'forward_to_store', :store_id => @store.id, :cart_id => @forward_cart.id, :store => {:login => StoreCartAPI.valid_login, :password => StoreCartAPI.valid_password}
    end

  end

end
