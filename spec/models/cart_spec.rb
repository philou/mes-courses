# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

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

  it "should remove all items when emptied" do
    @cart.add_item(@bavette)

    @cart.empty

    @cart.should be_empty
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
      @store_session = stub(MesCourses::StoreCarts::StoreCartSession).as_null_object
      @order = Order.new
      @order.stub!(:save!)
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

    it "should not add missing cart lines" do
      @order.should_not_receive(:add_missing_cart_lines)

      forward_to_store
    end

    it "should store the missing items names in the order" do
      fill_the_cart

      missing_lines = @cart.lines[2..3]
      missing_lines.each { |line| line.stub(:forward_to).and_raise(MesCourses::StoreCarts::UnavailableItemError) }
      missing_lines.each { |line| @order.should_receive(:add_missing_cart_line).with(line)}

      forward_to_store
    end

    it "should update the count of forwarded lines after each" do
      fill_the_cart

      @order.should_receive(:notify_forwarded_cart_line).exactly(@cart.lines.size).times

      forward_to_store
    end

    it "should save the order after each cart line is forwarded" do
      fill_the_cart

      @order.should_receive(:save!).exactly(@cart.lines.size).times

      forward_to_store
    end

    def forward_to_store
      @cart.forward_to(@store_session, @order)
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
