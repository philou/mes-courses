# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe CartController do

  before(:each) do
    @cart = stub_model(Cart)
    Cart.stub(:create).and_return(@cart)

    @store = stub_model(Store, :url => "http://www.mega-store.com")
    @stores = [@store]
    Store.stub(:find).and_return(@stores)
    Store.stub(:find_by_id).with(@store.id).and_return(@store)

    @cart.stub(:save!)
  end

  context "when using the session" do

    after(:each) do
      session[:cart_id].should == @cart.id

      assigns[:cart].should be @cart
      assigns[:stores].should be @stores
    end

    it "should assign the @path_bar to display" do
      get :show

      assigns[:path_bar].should == [PathBar.element_for_current_resource("Panier")]
    end

    # maybe I could use a shared_example, but I am not sure it would be better
    { Item => {:redirect => 'item_category', :find_stub_args => {} },
      Dish => {:redirect => 'dish', :find_stub_args => { :items => [] } } }.each do |model, options|

      redirection_controller = options[:redirect]
      model_small = model.to_s.downcase
      action = "add_#{model_small}".intern

      context "when adding #{model_small} to cart" do

        before(:each) do
          model.stub!(:find).and_return(stub_model(model, options[:find_stub_args]))

          @cart.should_receive(:save!)
        end

        it "should delegate to the cart" do
          thing = stub_model(model)
          model.stub(:find).and_return(thing)
          @cart.should_receive("add_#{model_small}".intern).with(thing)

          post_something(action, thing)
        end

        it "should not create a new session when one already exists" do
          session[:cart_id] = @cart.id
          Cart.should_not_receive(:new)
          Cart.should_receive(:find_by_id).and_return(@cart)

          post_a_stub(action, model)
        end

        it "should redirect to products" do
          post_a_stub(action, model)

          response.should redirect_to(:controller => redirection_controller)
        end
      end
    end

    def post_a_stub(action, model)
      post_something(action, stub_model(model))
    end
    def post_something(action, item)
      post( action, :id => item.id)
    end
  end

  context "forwarding to a store" do

    before(:each) do
      @logout_url = "#{@store.url}/deconnexion"
      @forward_cart = stub_model(Cart)
      @forward_cart.stub(:forward_to).and_return({ :store_url => @logout_url, :missing_items => []})
      Cart.should_receive(:find_by_id).with(@forward_cart.id).and_return(@forward_cart)
    end

    it "should assign a @path_bar with two items" do
      forward_to_valid_store_account

      assigns[:path_bar].should == [PathBar.element("Panier", :controller => 'cart'),
                                    PathBar.element_with_no_link("Transfert")]
    end

    it "should forward the cart instance to the store" do
      @forward_cart.should_receive(:forward_to).with(@store, StoreCartAPI.valid_login, StoreCartAPI.valid_password)
      forward_to_valid_store_account
    end

    it "should populate a forward report page" do
      forward_to_valid_store_account

      assigns[:store].should == @store
      assigns[:store_logout_url].should == @logout_url
      assigns[:report_notices].should_not be_nil
    end

    it "should fill report notices with missing items" do
      @forward_cart.stub(:forward_to).and_return({ :store_url => @logout_url, :missing_items => [stub_model(Item, :name => "Langue de Boeuf")]})

      forward_to_valid_store_account

      assigns[:report_notices].find_all{ |notice| notice =~ /Langue de Boeuf/ }.should have_at_least(1).item
    end

    context "using an invalid store account" do

      it "should redirect to cart" do
        forward_to_invalid_store_account
        response.should redirect_to(:controller => 'cart')
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
      @forward_cart.stub(:forward_to).and_raise(InvalidStoreAccountError)
      post 'forward_to_store', :store_id => @store.id, :cart_id => @forward_cart.id, :store => {:login => StoreCartAPI.invalid_login, :password => StoreCartAPI.invalid_password}
    end

  end

end
