# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'include_all_matcher'
require 'models/store_api_mock'

module Enumerable

  def map_inject(initial)
    memo = initial
    result = []
    each do |obj|
      memo = yield memo, obj
      result.push(memo)
    end
    result
  end

end

describe Cart do

  before(:each) do
    @bavette = stub_model(Item, :name => "Bavette", :price => 4.5)

    @cart = Cart.new
    @items = Array.new(5) {|i| stub_model(Item, :name => "item_#{i.to_s}", :price => 0.5 + i.to_f) }
  end

  it "should be empty when created" do
    @cart.should be_empty
  end

  it "should have no items when created" do
    @cart.lines.should be_empty
  end

  it "should not be empty once items were added" do
    @cart.add_item(@bavette)
    @cart.should_not be_empty
 end

  it "should contain added items" do
    fill_the_cart

    cart_should_contain_all_items
 end

  it "should contain items from added dishes" do
    @cart.add_dish(stub(Dish, :name => "Home made soup", :items => @items))
    cart_should_contain_all_items
  end

  it "should have a total price of 0 when empty" do
    @cart.total_price.should == 0
  end

  it "should have a total price of its item" do
    @cart.add_item(@bavette)
    @cart.total_price.should == 4.5
  end

  it "should have a total price equal to the sum of the prices of all its items" do
    @items.each {|item| @cart.add_item(item) }
    @cart.total_price.should == 12.5
  end

  context "when the same item was added twice" do

    before(:each) do
      @cart.add_item(@bavette)
    end

    it "should have only one cart item" do
      @cart.add_item(@bavette)
      @cart.lines.should have(1).entry
    end

    it "should have a cart item with quantity 2" do
      @cart.lines.first.should_receive(:increment_quantity)
      @cart.add_item(@bavette)
    end
  end

  context "when forwarding to an online store" do

    before :each do
      @cart = Cart.new
      @store = Store.new(:url => "http://www.a-store.com")
      @store_session = stub(StoreSession).as_null_object
      StoreSession.stub(:login).and_return(@store_session)
      @store_session.stub(:logout_url).and_return("http://www.a-store.com/logout")
      class << @store_session
        include WithLogoutMixin
      end
    end

    it "should login to the store" do
      StoreSession.should_receive(:login).with(@store.url, StoreAPI.valid_login, StoreAPI.valid_password)
      forward_to_store
    end

    it "should empty the remote cart" do
      @store_session.should_receive(:empty_the_cart)
      forward_to_store
    end

    it "should forward its lines" do
      fill_the_cart
      @cart.lines.each do |line|
        line.should_receive(:forward_to).with(@store_session)
      end

      forward_to_store
    end

    it "should eventually logout from the store" do
      @store_session.should_receive(:logout)
      forward_to_store
    end

    it "should logout from the store even if something went bad" do
      @store_session.stub(:empty_the_cart).and_raise(SocketError.new("Connection lost"))
      @store_session.should_receive(:logout)
      lambda { forward_to_store }.should raise_error(SocketError)
    end

    it "should return a map with the log out url of the store" do
      forward_to_store[:store_url].should == @store_session.logout_url
    end

    it "should return a map with the items that could not be bought" do
      forward_to_store[:missing_items].should_not be_nil
    end

    it "should return as missing items for the lines that could not be forwarded" do
      fill_the_cart

      @cart.lines[2].stub(:forward_to).and_raise(UnavailableItemError)
      @cart.lines[3].stub(:forward_to).and_raise(UnavailableItemError)

      forward_to_store[:missing_items].should have(2).items
    end

    def forward_to_store
      @cart.forward_to(@store, StoreAPI.valid_login, StoreAPI.valid_password)
    end
  end

  private

  def cart_should_contain_all_items
    @items.each do |added_item|
      cart_item = @cart.lines.detect {|line| line.item == added_item}
      cart_item.should_not be_nil
    end
  end

  def fill_the_cart
    @items.each do |item|
      @cart.add_item(item)
    end
  end

end
