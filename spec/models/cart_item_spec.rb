# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'include_all_matcher'

describe CartItem do

  before(:each) do
    @item = stub(Item, :name => "Bavette", :price => 4.5)
    @cart_item = CartItem.new(@item)
  end

  context "when created" do
    it "should have the price of its item" do
      @cart_item.price.should == @item.price
    end

    it "should have the name of its item" do
      @cart_item.name.should == @item.name
    end
  end

  it "should have the price of its item multiplied by its quantity" do
    5.times do
      @cart_item.price.should == @item.price * @cart_item.quantity
      @cart_item.increment_quantity
    end
  end

end
