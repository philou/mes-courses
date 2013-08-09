# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

shared_examples_for "Any Api" do

  it "should know its logout url" do
    logout_url = @store_cart_api.logout_url

    expect(logout_url).to(match(URI.regexp(['http'])), "#{logout_url} is not an http url !")
  end

  it "should know its login url" do
    expect(@store_cart_api.login_url).not_to be_empty
  end

  it "should know its login parameters" do
    expect(@store_cart_api.login_parameters(@store_cart_api.valid_login, @store_cart_api.valid_password)).not_to be_nil
  end

  it "should raise when login in with an invalid account" do
    expect(lambda {
             @store_cart_api.login("unknown-account", "wrong-password")
           }).to raise_error(MesCourses::Stores::Carts::InvalidAccountError)
  end

  context "with a valid account" do

    attr_reader :sample_item_id, :another_item_id, :store_cart_api

    before(:all) do
      @api = @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password)

      sample_items = extract_sample_items
      sample_item = sample_items.next
      @sample_item_id = sample_item.attributes[:remote_id]
      @another_item_id = extract_another_item_id(sample_items, sample_item)
    end
    before(:each) do
      @api.empty_the_cart
    end

    after(:all) do
      @api.logout
    end

    # Some tests are redudant with what is item extractions, but the followings
    # are clearer about what is expected from the cart

    it "should set the cart value to 0 when emptying the cart" do
      @api.add_to_cart(1, sample_item_id)

      @api.empty_the_cart
      expect(@api.cart_value).to eq 0
    end

    it "should set the cart value to something greater than 0 when adding items to the cart" do
      @api.empty_the_cart

      @api.add_to_cart(1, sample_item_id)
      expect(@api.cart_value).to be > 0
    end

    it "should set the cart value to 2 times that of one item when adding 2 items" do
      @api.empty_the_cart

      @api.add_to_cart(1, sample_item_id)
      item_price = @api.cart_value

      @api.add_to_cart(1, sample_item_id)
      expect(@api.cart_value).to eq 2*item_price
    end

    it "should set different cart values with different items" do
      sample_item_cart_value = cart_value_with_item(sample_item_id)
      another_item_cart_value = cart_value_with_item(another_item_id)

      expect(sample_item_cart_value).not_to eq another_item_cart_value
    end

    it "should synchronize different sessions with logout login" do
      @api.add_to_cart(1, sample_item_id)

      @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password).with_logout do |api2|
        api2.empty_the_cart
      end

      @api.logout
      @api = @store_cart_api.login(@store_cart_api.valid_login, @store_cart_api.valid_password)

      expect(@api.cart_value).to eq 0
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
      extract_sample_items_from(MesCourses::Stores::Items::Api.browse(@store_items_url))
    end

    def extract_sample_items_from(category)
      items = find_available_items(category)

      sub_items = nationaly_available_first(category.categories).lazy.map do |sub_category|
        extract_sample_items_from(sub_category)
      end

      [items, sub_items].lazy.flatten
    end

    def find_available_items(category)
      nationaly_available_first(category.items)
        .find_all {|item| item_available?(item.attributes[:remote_id]) }
    end

    def item_available?(item_id)
      @api.empty_the_cart
      @api.add_to_cart(1, item_id)
      item_price = @api.cart_value
      return false if 0 == item_price

      @api.add_to_cart(1, item_id)
      return @api.cart_value == item_price * 2
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

    def cart_value_with_item(item_id)
      @api.empty_the_cart
      @api.add_to_cart(1, item_id)
      @api.cart_value
    end
  end
end
