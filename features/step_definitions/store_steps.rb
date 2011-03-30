# Copyright (C) 2010, 2011 by Philippe Bourgau

Given /^the "([^"]*)" *(online)? store"?$/ do |web_store, online_store|
  test_online_if_possible = !online_store.blank?

  url = AUCHAN_DIRECT_OFFLINE
  @tweaks = {}

  if test_online_if_possible && online?
    url = "http://"+web_store
  end

  @store = Store.find_or_create_by_url(url)
end

# NOTE : I had to create another where the online url would not be overriden with
#        a local file because rails does not handle redirection to file://... well
# TODO : setup a real StoreAPIFactory, with a full blown TestStoreAPI, this could
#        clean the design and remove the stubs from cucumber
Given /^the "([^"]*)" store with api"?$/ do |web_store|
  @storeAPI = StoreAPIMock.new
  StoreAPI.stub!(:login) do |store_url, login, password|
    @storeAPI.login(store_url, login, password)
    @storeAPI
  end

  @store = Store.find_or_create_by_url("http://"+web_store)
end

Given /^items from the store were already imported$/ do
  lazy_import_with(@store, @tweaks)
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

  @storeAPI.add_unavailable_item(item)
end

When /^items from the store are imported$/ do
  import_with(@store, @tweaks)
end

When /^items from the store are re-imported$/ do
  reimport(@store, @tweaks)
end

When /^more items from the store are re-imported$/ do
  reimport(@store, @tweaks, :max_loop_nodes => 4)
end

When /^modified items from the store are re-imported$/ do
  reimport(@store, @tweaks, :price_increment => 1.1)
end

When /^sold out items from the store are re-imported$/ do
  reimport(@store, @tweaks, :max_loop_nodes => 2)
end

Then /^an empty cart should be created in the store account of the user$/ do
  @storeAPI.log.should include(:empty_the_cart)
end

Then  /^a non empty cart should be created in the store account of the user$/ do
  @storeAPI.log.should include(:set_item_quantity_in_cart)
end

