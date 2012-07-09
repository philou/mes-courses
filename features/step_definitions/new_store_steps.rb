# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

def generate_store(store_name, item_table)
  store = RealDummyStore.open(store_name)
  store.generate(3).categories.and(3).categories.and(3).items

  item_table.each_item do |category, sub_category, item|
    store.category(category).category(sub_category).item(item).generate().attributes
  end

  Store.create(url: store.uri, sponsored_url: store.uri)
end

def import_real_dummy_store(store_name)
  Store.find_by_url(RealDummyStore.uri(store_name)).import
end

def remove_items_from_generated_store(store_name, item_table)
  store = RealDummyStore.open(store_name)

  item_table.each_item do |category, sub_category, item|
    store.category(category).category(sub_category).remove_item(item)
  end
end

Given /^the "(.*?)" store with items$/ do |store_name, item_table|
  generate_store(store_name, item_table)
end

Given /^"(.*?)" store was already imported$/ do |store_name|
  import_real_dummy_store(store_name)
end

Given /^the imported store "(.*?)" with items$/ do |store_name, item_table|
  generate_store(store_name, item_table)
  import_real_dummy_store(store_name)
end

Given /^the following items were removed from "(.*?)"$/ do |store_name, item_table|
  remove_items_from_generated_store(store_name, item_table)
end

When /^"(.*?)" is imported again$/ do |store_name|
  import_real_dummy_store(store_name)
end

When /^the following items are removed from "(.*?)"$/ do |store_name, item_table|
  remove_items_from_generated_store(store_name, item_table)
  import_real_dummy_store(store_name)
end

