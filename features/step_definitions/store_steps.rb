# Copyright (C) 2010, 2011 by Philippe Bourgau

# TODO : try to get the DummyStoreCartAPI instance without using stubs
Given /^the "([^"]*)" store"?$/ do |web_store|
  @full_items_config = DummyStoreItemsAPI.complete_store_config
  DummyStoreItemsAPI.stub(:complete_store_config).and_return(DummyStoreItemsAPI.shrinked_config(@full_items_config, 2))

  @cart_api = DummyStoreCartAPI.new
  StoreCartAPI.stub!(:login) do |store_url, login, password|
    @cart_api.login(store_url, login, password)
    @cart_api
  end

  @store = Store.find_or_create_by_url("http://"+web_store)
end

def stubed_item
  items_api = DummyStoreItemsAPI.new_complete_store
  DummyStoreItemsAPI.stub(:new_complete_store).and_return(items_api)
  items_api.categories[1].categories[0].items[0]
end

Given /^items from the store were already imported$/ do
  @store.import
end

Given /^last store import was unexpectedly interrupted$/ do
  item = stubed_item
  item.stub(:attributes).and_raise(RuntimeError)

  begin
    @store.import

    true.should == false
  rescue RuntimeError
    # fake network error
  ensure
    item.unstub(:attributes)
  end
end

Given /^"([^"]*)" are unavailable in the store"?$/ do |item_name|
  item = Item.find_by_name(item_name)
  throw ArgumentError.new("Item '#{item_name}' could not be found") unless item

  @cart_api.add_unavailable_item(item.remote_id)
end

When /^items from the store are imported$/ do
  @store.import
end

When /^items from the store are re-imported$/ do
  reimport(@store)
end

When /^more items from the store are re-imported$/ do
  DummyStoreItemsAPI.stub(:complete_store_config).and_return(@full_items_config)
  reimport(@store)
end

When /^modified items from the store are re-imported$/ do
  item = stubed_item
  attributes = item.attributes
  item.stub(:attributes).and_return(attributes.merge(:price => attributes[:price] + 1.1))

  reimport(@store)
end

When /^sold out items from the store are re-imported$/ do
  DummyStoreItemsAPI.stub(:complete_store_config).and_return(DummyStoreItemsAPI.shrinked_config(@full_items_config, 1))
  reimport(@store)
end

Then /^an empty cart should be created in the store account of the user$/ do
  @cart_api.log.should include(:empty_the_cart)
end

Then  /^a non empty cart should be created in the store account of the user$/ do
  @cart_api.log.should include(:set_item_quantity_in_cart)
end

