require 'spec_helper'
require 'stub_helper'

describe CartController do
  include StubHelper

  it "should redirect to products when adding to cart" do
    stub_with_null_object!(Item, :new, :find)
    stub_with_null_object!(Cart, :new)

    post :add_to_cart, :id => stub_model(Item).object_id

    response.should redirect_to show_all_path(:controller => "items")
  end

  context "concerning the session cart" do

    before(:each) do
      @cart = stub(Cart)
    end

    after(:each) do
      session[:cart].should be @cart
    end

    context "without an existing session cart" do

      before(:each) do
        Cart.should_receive(:new).and_return(@cart)
      end

      it "creates an empty session cart when shown" do
        get :show
      end

      it "creates a session cart when a line is added" do
        it_should_add_the_item_to_the_cart
      end
    end

    context "with an existing session cart" do

      before(:each) do
        session[:cart] = @cart
        Cart.should_not_receive(:new)
      end

      it "displays the existing session cart when shown" do
        get :show
      end


      it "adds new lines to the existing session cart" do
        it_should_add_the_item_to_the_cart
      end
    end

    private

    def it_should_add_the_item_to_the_cart
      item = stub_model(Item)
      Item.should_receive(:find).once.and_return(item)
      @cart.should_receive(:add_item).with(item)

      post :add_to_cart, :id => item.object_id
    end
  end
end
