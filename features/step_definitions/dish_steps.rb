# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

Given /^there is a dish "([^"]*)""?$/ do |dish_name|
  item_names = dish_name.split(/ aux? /)

  if item_names.size == 1
    Dish.create!(:name => dish_name)

  else
    items = item_names.map do |item_name|
      FactoryGirl.create(:item, :name => item_name)
    end

    Dish.create!(:name => dish_name, :items => items)
  end
end

Given /^a dish "([^"]*)" with "([^"]*)"$/ do |name, item_name|
  item = Item.find_or_create_by_name(item_name)
  Dish.create!(:name => name, :items => [item])
end

Given /^the dish "(.*?)" with items$/ do |dish_name, item_table|
  items = item_table.raw.map do |item_name|
    Item.find_by_name(item_name)
  end
  Dish.create!(:name => dish_name, :items => items)
end

When /^I set the dish name to "([^"]*)"?"$/ do |name|
  fill_in("dish[name]", :with => name)
  click_button("Créer")
end

Then /^the dish "(.*?)" should still have items$/ do |dish_name, item_table|
  visit dish_path(Dish.find_by_name(dish_name))

  item_table.raw.each do |item_name|
    page.should contain_an(item_with_name(item_name[0]))
  end
end

Then /^the dish "(.*?)" should be disabled$/ do |dish_name|
  visit dishes_path
  page.should contain_a(disabled_dish_with_name(dish_name))
end

Then /^the dish "(.*?)" should be enabled$/ do |dish_name|
  visit dishes_path
  page.should contain_a(enabled_dish_with_name(dish_name))
end
