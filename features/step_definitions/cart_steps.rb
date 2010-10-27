# Copyright (C) 2010 by Philippe Bourgau

def given_in_cart(quantity, item_name)
  # maybe would be better find out how not to use side effects of functions
  item = Item.find_by_name(item_name)

  # this won't work if I have many items with the same item sub type
  quantity.times do
    visit item_sub_type_path(item.item_sub_type)
    click_link("Ajouter au panier")
  end
end
Given /^There (are|is) "([^"]*)" in the cart"?$/ do |_, item_name|
  given_in_cart(1, item_name)
end

Given /^There are (\d+) "([^"]*)" in the cart"?$/ do |quantity, item_name|
  given_in_cart(quantity.to_i, item_name)
end

Then /^There should be "([^"]*)" in my cart"?$/ do |item_name|
  visit path_to("the cart page")
  response.should contain(item_name)
end
