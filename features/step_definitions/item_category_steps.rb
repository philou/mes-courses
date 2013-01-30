# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2013 by Philippe Bourgau

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
    ItemCategory.find_by_name(name).should be_nil
  end
  ItemCategory.find_by_name(Constants::ROOT_ITEM_CATEGORY_NAME).should_not be_nil
  ItemCategory.find_by_name(Constants::DISABLED_ITEM_CATEGORY_NAME).should_not be_nil
end
