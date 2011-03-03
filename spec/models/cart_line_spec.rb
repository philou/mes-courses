# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'include_all_matcher'

describe CartLine do

  before(:each) do
    @item = stub(Item, :name => "Bavette", :price => 4.5)
    @cart_line = CartLine.new(@item)
  end

  context "when created" do
    it "should have the price of its item" do
      @cart_line.price.should == @item.price
    end

    it "should have the name of its item" do
      @cart_line.name.should == @item.name
    end
  end

  it "should have the price of its item multiplied by its quantity" do
    5.times do
      @cart_line.price.should == @item.price * @cart_line.quantity
      @cart_line.increment_quantity
    end
  end

  it "should add its items to the online cart when forwarded" do
    @cart_line.increment_quantity

    store_api = stub(StoreAPI)
    store_api.should_receive(:set_item_quantity_in_cart).once.with(@cart_line.quantity, @item)

    @cart_line.forward_to(store_api)
  end

end