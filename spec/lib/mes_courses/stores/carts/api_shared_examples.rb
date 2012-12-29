# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Carts

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
            @api.add_to_cart(1, sample_item_id)

            @api.empty_the_cart
            @api.cart_value.should == 0
          end

          it "should set the cart value to something greater than 0 when adding items to the cart" do
            @api.empty_the_cart

            @api.add_to_cart(1, sample_item_id)
            @api.cart_value.should >  0
          end

          it "should set the cart value to 2 times that of one item when adding 2 items" do
            @api.empty_the_cart

            @api.add_to_cart(1, sample_item_id)
            item_price = @api.cart_value

            @api.add_to_cart(1, sample_item_id)
            @api.cart_value.should == 2*item_price
          end

          it "should synchronize different sessions with logout login" do
            @api.add_to_cart(1, sample_item_id)

            @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password).with_logout do |api2|
              api2.empty_the_cart
            end

            @api.logout
            @api = @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password)

            @api.cart_value.should == 0
          end

          attr_reader :sample_item_id, :store_cart_api

          before(:all) do
            @sample_item_id = extract_sample_item
            @sample_item_id.should_not be_nil
          end

          private

          def extract_sample_item
            extract_sample_item_from(MesCourses::Stores::Items::Api.browse(@store_cart_api.url))
          end

          def extract_sample_item_from(category)
            item = find_available_item(category)
            return item if not item.nil?

            non_local_first(category.categories).each do |sub_category|
              item = extract_sample_item_from(sub_category)
              return item if not item.nil?
            end

            nil
          end

          def find_available_item(category)
            non_local_first(category.items).each do |item|
              item_id = item.attributes[:remote_id]
              if item_available?(item_id)
                return item_id
              end
            end

            nil
          end

          def item_available?(item_id)
            @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password).with_logout do |api|
              api.add_to_cart(1, item_id)
              return 0 < api.cart_value
            end
          end

          def non_local_first(elements)
            # Sometimes the tests used to fail because the sample item was not available
            # in the geographical region of the test user.
            milks, others = elements.partition { |element| is_milk(element) }
            milks + others
          end

          def is_milk(element)
            ["lait", "crème"].any? do |word|
              element.title.downcase.include?(word)
            end
          end
        end
      end
    end
  end
end
