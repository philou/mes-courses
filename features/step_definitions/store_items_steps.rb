# -*- encoding: utf-8 -*-
# Copyright (C) 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


Given /^the store "(.*?)"$/ do |store_name|
  generate_store(store_name)
end
Given /^the unimported store "(.*?)"$/ do |store_name|
  generate_store(store_name)
end
Given /^the unimported store "(.*?)" with items$/ do |store_name, item_table|
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

Given /^an unstable network interface/ do
  simulate_network_issues {|i| i%10 == 0}
end

Given /^last store import of "(.*?)" was unexpectedly interrupted$/ do |store_name|
  simulate_network_issues {|i| 5 < i}

  expect(lambda { import_real_dummy_store(store_name) }).to raise_error(RuntimeError)
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
  expect(Item.count).to eq items_count_in_generated_store(store_name)
end
