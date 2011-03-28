# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/store_api_mock'

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

      controller.instance_variable_get(:@cart).should be @cart
      controller.instance_variable_get(:@stores).should be @stores
    end

    it "should show the session cart" do
      get :show
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

          response.should redirect_to(ActionController::Routing::Routes.generate(:controller => redirection_controller))
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
      @forward_cart.stub(:forward_to).and_return(@logout_url)
      Cart.should_receive(:find_by_id).with(@forward_cart.id).and_return(@forward_cart)
    end

    it "should forward the cart instance to the store" do
      @forward_cart.should_receive(:forward_to).with(@store, StoreAPI.valid_login, StoreAPI.valid_password)
      forward_to_valid_store_account
    end

    it "should populate a forward report page" do
      forward_to_valid_store_account

      controller.instance_variable_get(:@store_url).should == @logout_url
      controller.instance_variable_get(:@report_messages).should_not be_empty
    end

    def forward_to_valid_store_account
      post 'forward_to_store', :store_id => @store.id, :cart_id => @forward_cart.id, :store => {:login => StoreAPI.valid_login, :password => StoreAPI.valid_password}
    end

  end

end
