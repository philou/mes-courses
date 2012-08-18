# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module MesCourses::Stores::Carts

  shared_examples_for "Any Api" do

    it "should know its logout url" do
      @store_cart_api.logout_url.should_not be_empty
    end

    it "should raise when login in with an invalid account" do
      lambda {
        @store_cart_api.login("unknown-account", "wrong-password")
      }.should raise_error(InvalidAccountError)
    end

    context "with a valid account" do

      before(:each) do
        @api = @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password)
      end
      after(:each) do
        @api.logout
      end

      it "should set the cart value to 0 when emptying the cart" do
        @api.set_item_quantity_in_cart(1, sample_item_id)

        @api.empty_the_cart
        @api.value_of_the_cart.should == 0
      end

      it "should set the cart value to something greater than 0 when adding items to the cart" do
        @api.empty_the_cart

        @api.set_item_quantity_in_cart(1, sample_item_id)
        @api.value_of_the_cart.should >  0
      end

      it "should set the cart value to 3 times that of one item when adding 3 items" do
        @api.empty_the_cart

        @api.set_item_quantity_in_cart(1, sample_item_id)
        item_price = @api.value_of_the_cart

        @api.set_item_quantity_in_cart(3, sample_item_id)
        @api.value_of_the_cart.should == 3*item_price
      end

      it "should synchronize different sessions with logout login" do
        @api.set_item_quantity_in_cart(1, sample_item_id)

        @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password).with_logout do |api2|
          api2.empty_the_cart
        end

        @api.logout
        @api = @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password)

        @api.value_of_the_cart.should == 0
      end

      attr_reader :sample_item_id, :store_cart_api

      before(:all) do
        @sample_item_id = extract_sample_item
        @sample_item_id.should_not be_nil
      end

      private

      def extract_sample_item
        produits_laitiers = milk_subcat(StoreItemsAPI.browse(@store_cart_api.url))
        produits_laitiers.should_not be_nil

        laits = milk_subcat(produits_laitiers)
        laits.should_not be_nil

        laits.items.each do |item|
          item_id = item.attributes[:remote_id]
          if item_available?(item_id)
            return item_id
          end
        end

        return nil
      end

      def item_available?(item_id)
        @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password).with_logout do |api|
          api.set_item_quantity_in_cart(1, item_id)
          return 0 < api.value_of_the_cart
        end
      end

      def milk_subcat(parent)
        parent.categories.each do |cat|
          return cat if cat.title.downcase.include?("lait")
        end

        return nil
      end

    end

  end
end
