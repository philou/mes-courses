# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'include_all_matcher'

describe Cart do

  before(:each) do
    @bavette = stub(Item, :name => "Bavette", :price => 4.5)

    @cart = Cart.new
    @items = Array.new(5) {|i| stub(Item, :name => "item_#{i.to_s}", :price => 0.5 + i.to_f) }
  end

  it "should have no items when created" do
    @cart.items.should be_empty
  end

  it "should contain added items" do
    @items.each {|item| @cart.add_item(item) }
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
      @cart.items.should have(1).entry
    end

    it "should have a cart item with quantity 2" do
      @cart.items.first.should_receive(:increment_quantity)
      @cart.add_item(@bavette)
    end
  end

  private

  def cart_should_contain_all_items
    @items.each do |added_item|
      cart_item = @cart.items.find {|item| item.name == added_item.name}
      cart_item.should_not be_nil
    end
  end

end
