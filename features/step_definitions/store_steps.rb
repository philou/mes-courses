# Copyright (C) 2010, 2011 by Philippe Bourgau

# TODO : try to get the DummyStoreCartAPI instance without using stubs
Given /^the "([^"]*)" store"?$/ do |web_store|
  @storeAPI = DummyStoreCartAPI.new
  StoreCartAPI.stub!(:login) do |store_url, login, password|
    @storeAPI.login(store_url, login, password)
    @storeAPI
  end

  @tweaks = {}
  @store = Store.find_or_create_by_url("http://"+web_store)
end

Given /^items from the store were already imported$/ do
  import_with(@store, @tweaks)
end

Given /^last store import was unexpectedly interrupted$/ do
  begin
    import_with(@store, @tweaks.merge(:simulate_error_at_node => 7))
  rescue RuntimeError
    # fake network error
  end
end

Given /^"([^"]*)" are unavailable in the store"?$/ do |item_name|
  item = Item.find_by_name(item_name)
  throw ArgumentError.new("Item '#{item_name}' could not be found") unless item

  @storeAPI.add_unavailable_item(item.remote_id)
end

When /^items from the store are imported$/ do
  import_with(@store, @tweaks)
end

When /^items from the store are re-imported$/ do
  reimport(@store, @tweaks)
end

When /^more items from the store are re-imported$/ do
  reimport(@store, @tweaks, :max_loop_nodes => 3)
end

When /^modified items from the store are re-imported$/ do
  reimport(@store, @tweaks, :price_increment => 1.1)
end

When /^sold out items from the store are re-imported$/ do
  reimport(@store, @tweaks, :max_loop_nodes => 1)
end

Then /^an empty cart should be created in the store account of the user$/ do
  @storeAPI.log.should include(:empty_the_cart)
end

Then  /^a non empty cart should be created in the store account of the user$/ do
  @storeAPI.log.should include(:set_item_quantity_in_cart)
end

