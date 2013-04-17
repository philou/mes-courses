# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

Given /the unimported store "(.*?)"$/ do |store_name|
  generate_store(store_name)
end

Given /^the imported store "(.*?)"$/ do |store_name|
  generate_store(store_name)
  import_real_dummy_store(store_name)
  note_past_metrics
end

Given /^the imported store "(.*?)" with items$/ do |store_name, item_table|
  generate_store(store_name, item_table)
  import_real_dummy_store(store_name)
  note_past_metrics
end

Given /an unstable network interface/ do
  i = 0

  original_open = MesCourses::Stores::Items::WalkerPage.method(:open)
  MesCourses::Stores::Items::WalkerPage.stub(:open).with(anything()) do |*args|
    i = i+1
    raise RuntimeError.new("network down") if i%3 == 0
    original_open.call(*args)
  end
end

When /^"(.*?)" is imported$/ do |store_name|
  import_real_dummy_store(store_name)
end

When /^"(.*?)" is imported again$/ do |store_name|
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
When /^"(.*?)" raises its prices$/ do |store_name|
  raise_prices_in_generated_store(store_name)
  import_real_dummy_store(store_name)
end

Then /^all items from "(.*?)" should have been imported$/ do |store_name|
  Item.count.should == items_count_in_generated_store(store_name)
end
