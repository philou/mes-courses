# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'stub_helper'

describe CartController do
  include StubHelper

  before(:each) do
    @cart = stub(Cart).as_null_object
    Cart.stub(:new).and_return(@cart)

    @store = stub_model(Store, :url => "http://www.mega-store.com")
    @stores = [@store]
    Store.stub(:find).and_return(@stores)
    Store.stub(:find_by_id).and_return(@store)
  end

  after(:each) do
    session[:cart].should be @cart
    controller.instance_variable_get(:@cart).should be @cart
    controller.instance_variable_get(:@stores).should be @stores
  end

  it "should show the session cart" do
    get :show
  end

  # maybe I could use a shared_example, but I am not sure it would be better
  { Item => 'item_category',
    Dish => 'dish'}.each do |model, redirection_controller|

    model_small = model.to_s.downcase
    action = "add_#{model_small}".intern

    context "when adding #{model_small} to cart" do

      before(:each) do
        stub_with_null_object!(model, :find)
      end

      it "should delegate to the cart" do
        thing = stub_model(model)
        model.stub(:find).and_return(thing)
        @cart.should_receive("add_#{model_small}".intern).with(thing)

        post_something(action, thing)
      end

      it "should not create a new session when one already exists" do
        session[:cart] = @cart
        Cart.should_not_receive(:new)

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

  context "forwarding to a store" do

    VALID_LOGIN = "valid-login"
    VALID_PASSWORD = "valid-password"

    before :each do
      @store_api = stub(StoreAPI).as_null_object
      StoreAPI.stub(:login).and_return(@store_api)
    end

    it "should login to the store" do
      StoreAPI.should_receive(:login).with(VALID_LOGIN, VALID_PASSWORD)
      forward_to_valid_store_account
    end

    it "should empty the remote cart" do
      @store_api.should_receive(:empty_the_cart)
      forward_to_valid_store_account
    end

    it "should redirect response to the store" do
      forward_to_valid_store_account
      response.should redirect_to @store.url
    end

    it "should eventually logout from the store" do
      @store_api.should_receive(:logout)
      forward_to_valid_store_account
    end

    it "should logout from the store even if something went bad" do
      @store_api.stub(:empty_the_cart).and_raise(SocketError.new("Connection lost"))
      @store_api.should_receive(:logout)
      lambda { forward_to_valid_store_account }.should raise_error(SocketError)
    end

    def forward_to_valid_store_account
      post 'forward_to_store', :id => @store.id, :store => {:login => VALID_LOGIN, :password => VALID_PASSWORD}
    end

  end

end
