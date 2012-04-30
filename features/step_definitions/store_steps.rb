# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'cucumber/rspec/doubles'

def configure_dummy_store(items_config)
  # Using stubs with item api makes sure the static modifications are rolledback after each scenario
  DummyStoreItemsAPI.stub(:new_default_store).and_return(DummyStoreItemsAPI.new(items_config))
end

def given_a_sample_item
  DummyStoreItemsAPI.new_default_store.categories[1].categories[0].items[0]
end

def remove_item_from(category_config, item_name)
  category_config[:items] = category_config[:items].reject{ |item| item[:attributes][:name] == item_name }
  category_config[:categories].each do |sub_category_config|
    remove_item_from(sub_category_config, item_name)
  end
end

Given /^the "([^"]*)" store"?$/ do |web_store|
  new_import_retrier_options = Store.import_retrier_options.merge(:sleep_delay => 0)
  Store.stub(:import_retrier_options).and_return(new_import_retrier_options)

  @items_config = DummyStoreItemsAPI.shrinked_config(2)
  configure_dummy_store(@items_config)

  @cart_api = DummyStoreCartAPI.new
  DummyStoreCartAPI.stub(:login) do |login,password|
    @cart_api.relog(login, password)
    @cart_api
  end

  @store = Store.find_or_create_by_url("http://"+web_store) { |store| store.sponsored_url = "http://#{web_store}/sponsored" }
end

Given /^items from the store were already imported$/ do
  Store.import
end

Given /^last store import was unexpectedly interrupted$/ do
  item = given_a_sample_item
  item.stub(:attributes).and_raise(RuntimeError)

  begin
    Store.import
  rescue RuntimeError
    # fake network error
  ensure
    item.unstub(:attributes)
  end
end

Given /^the network connection is unstable$/ do
  item = given_a_sample_item
  item.stub(:attributes) do
    item.unstub(:attributes)
    raise RuntimeError.new("network down")
  end
end

Given /^there are 2 items with the name "([^"]*)""? in the store$/ do |name|
  [["extra", 10001], ["extra fins", 1002]].each do |summary, remote_id|
    @items_config[:categories][0][:categories][0][:items].push({ :uri => URI.parse("http://www.dummy-store.com/article/#{remote_id}"),
                                                                 :items => [],
                                                                 :categories => [],
                                                                 :attributes => {
                                                                   :name => name,
                                                                   :summary => "#{name} #{summary}",
                                                                   :image => "http://www.dummy-store.com/images/#{remote_id}",
                                                                   :price => 1.2,
                                                                   :remote_id => remote_id }})
  end
  configure_dummy_store(@items_config)
end

Given /^"([^"]*)" are unavailable in the store"?$/ do |item_name|
  item = Item.find_by_name(item_name)
  throw ArgumentError.new("Item '#{item_name}' could not be found") unless item

  @cart_api.add_unavailable_item(item.remote_id)
end

Given /^"([^"]*)" was removed from the store"?$/ do |item_name|
  remove_item_from(@items_config, item_name)
  configure_dummy_store(@items_config)
end

When /^items from the store are imported$/ do
  Store.import
end

When /^items from the store are re-imported$/ do
  reimport(@store)
end

When /^more items from the store are re-imported$/ do
  configure_dummy_store(DummyStoreItemsAPI.full_config)
  reimport(@store)
end

When /^modified items from the store are re-imported$/ do
  item = given_a_sample_item
  attributes = item.attributes
  item.stub(:attributes).and_return(attributes.merge(:price => attributes[:price] + 1.1))

  reimport(@store)
end

When /^sold out items from the store are re-imported$/ do
  configure_dummy_store(DummyStoreItemsAPI.shrinked_config(1))
  reimport(@store)
end

Then /^an empty cart should be created in the store account of the user$/ do
  @cart_api.log.should include(:empty_the_cart)
end

Then  /^a non empty cart should be created in the store account of the user$/ do
  @cart_api.log.should include(:set_item_quantity_in_cart)
end

Then /^all items from the store should have been imported$/ do
  Item.should have(DummyStoreItemsAPI.new_default_store.total_items_count).records
end

