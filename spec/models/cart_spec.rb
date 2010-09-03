# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'include_all_matcher'

describe Cart do

  before(:each) do
    @cart = Cart.new
    @items = Array.new(5) {|i| stub(Item, :name => "item_#{i.to_s}") }
  end

  it "should have no items when created" do
    @cart.items.should be_empty
  end

  it "should contain added items" do
    @items.each {|item| @cart.add_item(item) }
    @cart.items.should include_all(@items)
  end

  it "should contain items from added dishes" do
    @cart.add_dish(stub(Dish, :name => "Home made soup", :items => @items))
    @cart.items.should include_all(@items)
  end

end
