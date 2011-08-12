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
      @order = stub_model(Order)
      Order.stub(:create!).and_return(@order)

      @logout_url = "#{@store.url}/deconnexion"
      @missing_items_names = ""
      @forward_cart = stub_model(Cart)
      @forward_cart.stub(:forward_to) do | session, order|
        order.forwarded_cart_lines_count = @forward_cart.lines.size
        order.missing_items_names = @missing_items_names
        order.remote_store_order_url = @logout_url
      end

      Cart.stub(:find_by_id).with(@forward_cart.id).and_return(@forward_cart)

      @store_session = stub(StoreCartSession).as_null_object
      StoreCartSession.stub(:login).with(@store.url, StoreCartAPI.valid_login, StoreCartAPI.valid_password).and_return(@store_session)
      class << @store_session
        include WithLogoutMixin
      end
    end

    it "should assign a @path_bar with two items" do
      forward_to_valid_store_account

      assigns[:path_bar].should == [PathBar.element("Panier", :controller => 'cart_lines'),
                                    PathBar.element_with_no_link("Transfert")]
    end

    it "should forward the cart instance to the store" do
      @forward_cart.should_receive(:forward_to).with(@store_session, @order)
      forward_to_valid_store_account
    end

    it "should create an order with cart and store" do
      Order.should_receive(:create!).with({ :cart => @forward_cart, :store => @store })

      forward_to_valid_store_account
    end

    it "should logout from the store even if something went bad" do
      @forward_cart.stub(:forward_to).and_raise(SocketError.new("Connection lost"))
      @store_session.should_receive(:logout)
      lambda { forward_to_valid_store_account }.should raise_error(SocketError)
    end

    it "should eventually logout from the store" do
      @store_session.should_receive(:logout)
      forward_to_valid_store_account
    end

    it "should populate a forward report page" do
      forward_to_valid_store_account

      assigns[:store].should == @store
      assigns[:store_logout_url].should == @logout_url
      assigns[:report_notices].should_not be_nil
    end

    it "should fill report notices with missing items" do
      missing_items = ["Langue de Boeuf","nCervelle d'agneau"]
      @missing_items_names = missing_items.join("\n")

      forward_to_valid_store_account

      missing_items.each do |item_name|
        assigns[:report_notices].find_all{ |notice| notice.include?("'#{item_name}'") }.should have_at_least(1).item
      end
    end

    context "using an invalid store account" do

      it "should redirect to cart" do
        forward_to_invalid_store_account
        response.should redirect_to(:controller => 'cart_lines')
      end

      it "should set a flash message" do
        forward_to_invalid_store_account

        flash[:notice].should_not be_blank
      end
    end

    def forward_to_valid_store_account
      post 'forward_to_store', :store_id => @store.id, :cart_id => @forward_cart.id, :store => {:login => StoreCartAPI.valid_login, :password => StoreCartAPI.valid_password}
    end

    def forward_to_invalid_store_account
      StoreCartSession.stub(:login).and_raise(InvalidStoreAccountError)
      post 'forward_to_store', :store_id => @store.id, :cart_id => @forward_cart.id, :store => {:login => StoreCartAPI.invalid_login, :password => StoreCartAPI.invalid_password}
    end

  end

end