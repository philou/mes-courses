# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

def generate_store(store_name, item_table = :no_extra_items)
  store = MesCourses::Stores::Items::RealDummy.open(store_name)
  store.generate(3).categories.and(3).categories.and(3).items

  unless item_table == :no_extra_items
    add_items_to_generated_store(store_name, item_table)
  end

  Store.create(url: store.uri, sponsored_url: store.uri)
end

def import_real_dummy_store(store_name)
  Store.find_by_url(MesCourses::Stores::Items::RealDummy.uri(store_name)).import
end

def add_items_to_generated_store(store_name, item_table)
  store = MesCourses::Stores::Items::RealDummy.open(store_name)

  item_table.each_item do |category, sub_category, item|
    store.category(category).category(sub_category).item(item).generate().attributes
  end
end
def remove_items_from_generated_store(store_name, item_table)
  store = MesCourses::Stores::Items::RealDummy.open(store_name)

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

Given /^the imported store "(.*?)"$/ do |store_name|
  generate_store(store_name)
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
  note_past_metrics
  import_real_dummy_store(store_name)
end

When /^the following items are added to "(.*?)"$/ do |store_name, item_table|
  add_items_to_generated_store(store_name, item_table)
  import_real_dummy_store(store_name)
end
When /^the following items are removed from "(.*?)"$/ do |store_name, item_table|
  remove_items_from_generated_store(store_name, item_table)
  import_real_dummy_store(store_name)
end

