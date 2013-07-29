# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe CartLinesController do
  include PathBarHelper

  ignore_user_authentication

  before(:each) do
    @cart = stub_model(Cart)
    @cart.stub(:save!)
    @cart.stub(:add_dish)
    Cart.stub(:create).and_return(@cart)

    @store = stub_model(Store, :url => "http://www.mega-store.com")
    @stores = [@store]
    Store.stub(:all).and_return(@stores)
    Store.stub(:find_by_id).with(@store.id).and_return(@store)
  end

  context "session handling" do

    before :each do
      Item.stub(:find).and_return(stub_model(Item))
      Dish.stub(:find).and_return(stub_model(Dish))
    end

    def self.it_should_find_or_create_a_session_when_answering (action, &http_request)
      context "when answering #{action}" do

        it "should create a new cart in session if no one exists" do
          instance_eval(&http_request)

          session[:cart_id].should == @cart.id
        end

        it "should reuse existing cart from session if one exists" do
          session[:cart_id] = @cart.id
          Cart.stub(:find_by_id).with(@cart.id).and_return(@cart)

          Cart.should_not_receive(:create)

          instance_eval(&http_request)
        end

      end
    end

    it_should_find_or_create_a_session_when_answering(:index) { get :index }
    it_should_find_or_create_a_session_when_answering(:destroy_all) { delete :destroy_all}
    it_should_find_or_create_a_session_when_answering(:create) { post :create}
    it_should_find_or_create_a_session_when_answering(:add_dish) { post :add_dish, :id => @cart.id }

  end


  it "should assign a path_bar with index" do
    get :index

    assigns(:path_bar).should == [path_bar_cart_lines_root]
  end

  it "should assign a cart with index" do
    get :index

    assigns(:cart).should == @cart
  end

  it "should assign stores with index" do
    get :index

    assigns(:stores).should == @stores
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
      Item.stub(:find).and_return(@item)
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
      Dish.stub(:find).and_return(@dish)
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


end
