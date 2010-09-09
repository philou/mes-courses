# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'stub_helper'

describe CartController do
  include StubHelper

  before(:each) do
    @cart = stub(Cart).as_null_object
    Cart.stub(:new).and_return(@cart)
  end

  after(:each) do
    session[:cart].should be @cart
    instance_variable_get(:@cart).should be @cart
  end

  it "should show the session cart" do
    get :show
  end

  # maybe I could use a shared_example, but I am not sure it would be better
  { Item => 'item_type',
    Dish => 'dish'}.each do |model, redirection_controller|
    model_small = model.to_s.downcase
    action = "add_#{model_small}_to_cart".intern

    context "when adding #{model_small} to cart" do

      before(:each) do
        stub_with_null_object!(model, :find)
      end

      it "should forward to the cart" do
        thing = stub_model(model)
        model.stub(:find).and_return(thing)
        @cart.should_receive("add_#{model_small}".intern).with(thing)

        post_item(action, thing)
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
    post_item(action, stub_model(model))
  end
  def post_item(action, item)
    post( action, :id => item.object_id)
  end

end
