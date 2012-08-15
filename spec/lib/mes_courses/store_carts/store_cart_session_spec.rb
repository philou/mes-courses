# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module StoreCarts

    describe StoreCartSession do

      before :each do
        @store_api = stub(StoreCartAPI).as_null_object
        @store_api.stub(:value_of_the_cart).and_return(2.0)

        @store_session = StoreCartSession.new(@store_api)

        @bavette = stub_model(Item, :name => "bavette", :price => 5.3, :remote_id => 12345)
        @pdt = stub_model(Item, :name => "PdT", :price => 2.5, :remote_id => 67890)
      end

      it "should delegate logout to the store api" do
        ensure_delegates :logout
      end

      it "should delegate emptying the cart to the store api" do
        ensure_delegates :empty_the_cart
      end

      it "should delegate value of the cart to the store api" do
        ensure_delegates_read :value_of_the_cart, 3.1
      end

      it "should delegate adding items to the cart to the store api" do
        @store_api.stub(:value_of_the_cart).and_return(0.0, 5.0)

        @store_api.should_receive(:set_item_quantity_in_cart).once.with(1, @bavette.remote_id)

        @store_session.set_item_quantity_in_cart(1, @bavette)
      end

      it "should not ask the value if it already knows it" do
        @store_api.should_receive(:value_of_the_cart).exactly(1).times
        2.times do
          @store_session.value_of_the_cart
        end
      end

      it "should change the value after adding items" do
        @store_api.stub(:value_of_the_cart).and_return(3.0, 5.0)

        old_value = @store_session.value_of_the_cart
        @store_session.set_item_quantity_in_cart(3, @pdt)
        @store_session.value_of_the_cart.should_not == old_value
      end


      it "should throw when value of the cart does not change after adding items" do
        lambda {
          @store_session.set_item_quantity_in_cart(4, @pdt)
        }.should raise_error(UnavailableItemError)
      end

      it "should not throw if setting the quantity to 0.0" do
        @store_session.set_item_quantity_in_cart(0, @bavette)

        lambda {
          @store_session.set_item_quantity_in_cart(0, @pdt)
        }.should_not raise_error
      end

      def ensure_delegates_read(message, value)
        @store_api.stub(message).and_return(value)
        @store_session.send(message).should == value
      end
      def ensure_delegates(message, args = [])
        @store_api.should_receive(message).once.with(*args)
        @store_session.send message, *args
      end

    end

  end
end
