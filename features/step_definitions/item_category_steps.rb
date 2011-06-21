# Copyright (C) 2011 by Philippe Bourgau

Given /^there is an? "([^"]*)" item category"?$/ do |name|
  ItemCategory.find_or_create_by_name_and_parent_id(name, ItemCategory.root.id)
end

Given /^there is an? "([^">]*) > ([^"]*)" item sub category$/ do |type, category|
  item_category = ItemCategory.find_or_create_by_name_and_parent_id(type, ItemCategory.root.id)
  ItemCategory.create!(:name => category, :parent => item_category)
end

When /^I search for "([^"]*)"?"$/ do |keyword|
  fill_in("search[keyword]", :with => keyword)
  click_button("Rechercher")
end
