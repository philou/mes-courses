# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'stub_helper'
require 'models/store_api_mock'

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

    before(:each) do
      @logout_url = "#{@store.url}/deconnexion"
      @cart.stub(:forward_to).and_return(@logout_url)
    end

    it "should forward the cart instance to the store" do
      @cart.should_receive(:forward_to).with(@store, StoreAPI.valid_login, StoreAPI.valid_password)
      forward_to_valid_store_account
    end

    it "should redirect response to the store" do
      forward_to_valid_store_account
      response.should redirect_to(@logout_url)
    end

    def forward_to_valid_store_account
      post 'forward_to_store', :id => @store.id, :store => {:login => StoreAPI.valid_login, :password => StoreAPI.valid_password}
    end

  end

end
