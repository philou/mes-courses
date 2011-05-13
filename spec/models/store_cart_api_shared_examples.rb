# Copyright (C) 2011 by Philippe Bourgau

require 'rubygems'
require 'spec_helper'
require 'lib/offline_test_helper'

include OfflineTestHelper

shared_examples_for "Any StoreCartAPI" do

  if offline?
    puts yellow "WARNING: skipping StoreCartAPI remote spec because tests are running offline."

  else

    it "should raise when login in with an invalid account" do
      lambda {
        @store_cart_api.new("unknown-account", "wrong-password")
      }.should raise_error(InvalidStoreAccountError)
    end

    context "with a valid account" do

      before(:each) do
        @api = @store_cart_api.new(@store_cart_api.valid_login, @store_cart_api.valid_password)
      end
      after(:each) do
        @api.logout
      end

      it "should set the cart value to 0 when emptying the cart" do
        @api.set_item_quantity_in_cart(1, sample_item)

        @api.empty_the_cart
        @api.value_of_the_cart.should == 0
      end

      it "should set the cart value to something greater than 0 when adding items to the cart" do
        @api.empty_the_cart

        @api.set_item_quantity_in_cart(1, sample_item)
        @api.value_of_the_cart.should >  0
      end

      it "should set the cart value to 3 times that of one item when adding 3 items" do
        @api.empty_the_cart

        @api.set_item_quantity_in_cart(1, sample_item)
        item_price = @api.value_of_the_cart

        @api.set_item_quantity_in_cart(3, sample_item)
        @api.value_of_the_cart.should == 3*item_price
      end

      it "should synchronize different sessions with logout login" do
        @api.set_item_quantity_in_cart(1, sample_item)

        @store_cart_api.new(@store_cart_api.valid_login, @store_cart_api.valid_password).with_logout do |api2|
          api2.empty_the_cart
        end

        @api.logout
        @api = @store_cart_api.new(@store_cart_api.valid_login, @store_cart_api.valid_password)

        @api.value_of_the_cart.should == 0
      end

      attr_reader :sample_item, :store_cart_api

      before(:all) do
        @sample_item = extract_sample_item
        @sample_item.should_not be_nil
      end

      private

      def extract_sample_item
        produits_laitiers = milk_subcat(StoreItemsAPI.browse(@store_cart_api.url))
        produits_laitiers.should_not be_nil

        laits = milk_subcat(produits_laitiers)
        laits.should_not be_nil

        laits.items.each do |item|
          attributes = item.attributes
          if attributes[:price] != 0.0
            return attributes[:remote_id]
          end
        end

        return nil
      end

      def milk_subcat(parent)
        parent.categories.each do |cat|
          return cat if cat.link_text.downcase.include?("lait")
        end

        return nil
      end

    end

  end

end