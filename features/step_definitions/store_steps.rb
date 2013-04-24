# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'cucumber/rspec/doubles'

Given /^the "([^"]*)" store"?$/ do |web_store|
  @cart_api = MesCourses::Stores::Carts::DummyApi.new
  MesCourses::Stores::Carts::DummyApi.stub(:login) do |login,password|
    @cart_api.relog(login, password)
    @cart_api
  end

  @store = Store.find_or_create_by_url("http://"+web_store) { |store| store.sponsored_url = "http://#{web_store}/sponsored" }
end


# store cart steps
Given /^"([^"]*)" are unavailable in the store"?$/ do |item_name|
  item = Item.find_by_name(item_name)
  throw ArgumentError.new("Item '#{item_name}' could not be found") unless item

  @cart_api.add_unavailable_item(item.remote_id)
end

Then /^an empty cart should be created in the store account of the user$/ do
  @cart_api.log.should include(:empty_the_cart)
end

Then  /^a non empty cart should be created in the store account of the user$/ do
  @cart_api.log.should include(:add_to_cart)
end


