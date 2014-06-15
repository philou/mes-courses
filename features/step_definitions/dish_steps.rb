# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
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


GivenEither(/^(#{CAPTURE_DISH_NAME})$/,
            /^the dishes$/) do |table|
  create_dishes(table)
end

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

When /^I remove "([^"]*)"?" from the dish$/ do |name|
  page.find(:xpath, item_with_name(name).xpath).find_button("Enlever de la recette").click
end

Then /^the dish "(.*?)" should still have items$/ do |dish_name, item_table|
  visit dish_path(Dish.find_by_name(dish_name))

  item_table.raw.each do |item_name|
    expect(page).to contain_an(item_with_name(item_name[0]))
  end
end

Then /^the dish "(.*?)" should be disabled$/ do |dish_name|
  visit dishes_path
  expect(page).to contain_a(disabled_dish_with_name(dish_name))
end

Then /^the dish "(.*?)" should be enabled$/ do |dish_name|
  visit dishes_path
  expect(page).to contain_a(enabled_dish_with_name(dish_name))
end
