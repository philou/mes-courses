# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

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

          it "should set different cart values with different items" do
            sample_item_cart_value = cart_value_with_item(sample_item_id)
            another_item_cart_value = cart_value_with_item(another_item_id)

            sample_item_cart_value.should_not == another_item_cart_value
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

          it "should logout with HTTP GET" do
            unless http_agent.nil?
              @api.add_to_cart(1, sample_item_id)
              @api.cart_value.should_not == 0

              http_agent.get(@api.logout_url)

              @api.cart_value.should == 0
            end
          end

          attr_reader :sample_item_id, :another_item_id, :store_cart_api

          before(:all) do
            sample_items = extract_sample_items
            sample_item = sample_items.next
            @sample_item_id = sample_item.attributes[:remote_id]
            @another_item_id = extract_another_item_id(sample_items, sample_item)
          end

          private

          def extract_another_item_id(sample_items, sample_item)
            another_item = sample_item
            while sample_item.attributes[:price] == another_item.attributes[:price]
              another_item = sample_items.next
            end
            another_item.attributes[:remote_id]
          end

          def extract_sample_items
            extract_sample_items_from(MesCourses::Stores::Items::Api.browse(@store_cart_api.url))
          end

          def extract_sample_items_from(category)
            items = find_available_items(category)

            sub_items = nationaly_available_first(category.categories).mapping do |sub_category|
              extract_sample_items_from(sub_category)
            end

            items.concating(sub_items.flattening)
          end

          def find_available_items(category)
            nationaly_available_first(category.items)
              .finding_all {|item| item_available?(item.attributes[:remote_id]) }
          end

          def item_available?(item_id)
            @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password).with_logout do |api|
              api.add_to_cart(1, item_id)
              return 0 < api.cart_value
            end
          end

          def nationaly_available_first(elements)
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

          def http_agent
            @api.instance_eval do
              @agent
            end
          end

          def cart_value_with_item(item_id)
            @api.empty_the_cart
            @api.add_to_cart(1, item_id)
            @api.cart_value
          end
        end
      end
    end
  end
end
