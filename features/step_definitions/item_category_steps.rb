# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2013 by Philippe Bourgau
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


Given /^there is an? "([^"]*)" item category"?$/ do |name|
  ItemCategory.find_or_create_by_name_and_parent_id(name, ItemCategory.root.id)
end

Given /^there is an? "([^">]*) > ([^"]*)" item sub category$/ do |type, category|
  item_category = ItemCategory.find_or_create_by_name_and_parent_id(type, ItemCategory.root.id)
  ItemCategory.create!(:name => category, :parent => item_category)
end

When /^I search for "([^"]*)"?"$/ do |search_string|
  fill_in("search[search_string]", :with => search_string)
  click_button("Rechercher")
end

Then /^the following categories should have been deleted$/ do |item_categories|
  item_categories.raw.each do |name|
    expect(ItemCategory.find_by_name(name)).to be_nil
  end
  expect(ItemCategory.find_by_name(Constants::ROOT_ITEM_CATEGORY_NAME)).not_to be_nil
  expect(ItemCategory.find_by_name(Constants::DISABLED_ITEM_CATEGORY_NAME)).not_to be_nil
end
