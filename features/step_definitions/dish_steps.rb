# Copyright (C) 2010, 2011 by Philippe Bourgau

Given /^"([^ ]*) au ([^"]*)" is a known dish"?$/ do |item1, item2|
  items = [item1,item2].map do |item|
    Factory.create(:item, :name => item)
  end

  @known_dish = Dish.create!(:name => "#{item1} au #{item2}", :items => items)
end

When /^I set the dish name to "([^"]*)"?"$/ do |name|
  fill_in("dish[name]", :with => name)
  click_button("Créer")
end
