# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau

Given /the store "(.*?)"$/ do |store_name|
  generate_store(store_name)
end
Given /the unimported store "(.*?)"$/ do |store_name|
  generate_store(store_name)
end
Given /the unimported store "(.*?)" with items$/ do |store_name, item_table|
  generate_store(store_name, item_table)
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
  simulate_network_issues {|i| i%10 == 0}
end

Given /^last store import of "(.*?)" was unexpectedly interrupted$/ do |store_name|
  simulate_network_issues {|i| 5 < i}

  lambda { import_real_dummy_store(store_name) }.should raise_error(RuntimeError)
  note_past_metrics

  fix_network_issues
end

Given(/^"(.*?)" raised its prices$/) do |store_name|
  raise_prices_in_generated_store(store_name)
end

When /^"(.*?)" is imported$/ do |store_name|
  import_real_dummy_store(store_name)
end

When /^"(.*?)" is imported again$/ do |store_name|
  import_real_dummy_store(store_name)
end

When /^the scheduled automatic imports are ran$/ do
  Store.import
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
