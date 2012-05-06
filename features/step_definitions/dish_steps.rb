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

    @known_dish = Dish.create!(:name => dish_name, :items => items)
  end
end

Given /^a dish "([^"]*)" with "([^"]*)"$/ do |name, item_name|
  item = Item.find_or_create_by_name(item_name)
  Dish.create!(:name => name, :items => [item])
end

When /^I set the dish name to "([^"]*)"?"$/ do |name|
  fill_in("dish[name]", :with => name)
  click_button("Créer")
end
