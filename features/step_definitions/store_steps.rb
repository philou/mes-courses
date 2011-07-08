# Copyright (C) 2010, 2011 by Philippe Bourgau

# TODO : try to get the DummyStoreCartAPI instance without using stubs
Given /^the "([^"]*)" store"?$/ do |web_store|
  @default_items_config = DummyStoreItemsAPI.default_store_config
  @items_config = DummyStoreItemsAPI.shrinked_config(@default_items_config, 2)
  DummyStoreItemsAPI.stub(:default_store_config).and_return(@items_config)

  @cart_api = DummyStoreCartAPI.new
  StoreCartAPI.stub!(:login) do |store_url, login, password|
    @cart_api.login(store_url, login, password)
    @cart_api
  end

  @store = Store.find_or_create_by_url("http://"+web_store)
end

def stubed_item
  items_api = DummyStoreItemsAPI.new_default_store
  DummyStoreItemsAPI.stub(:new_default_store).and_return(items_api)
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
  DummyStoreItemsAPI.stub(:default_store_config).and_return(@default_items_config)
  reimport(@store)
end

When /^modified items from the store are re-imported$/ do
  item = stubed_item
  attributes = item.attributes
  item.stub(:attributes).and_return(attributes.merge(:price => attributes[:price] + 1.1))

  reimport(@store)
end

When /^sold out items from the store are re-imported$/ do
  DummyStoreItemsAPI.stub(:default_store_config).and_return(DummyStoreItemsAPI.shrinked_config(@default_items_config, 1))
  reimport(@store)
end

Then /^an empty cart should be created in the store account of the user$/ do
  @cart_api.log.should include(:empty_the_cart)
end

Then  /^a non empty cart should be created in the store account of the user$/ do
  @cart_api.log.should include(:set_item_quantity_in_cart)
end

