# Copyright (C) 2010, 2011 by Philippe Bourgau

def given_in_cart(quantity, item_name)
  # maybe would be better find out how not to use side effects of functions
  item = Item.find_by_name(item_name)
  throw ArgumentError.new ("Item '#{item_name}' could not be found") unless item

  # this won't work if I have many items with the same item category
  quantity.times do
    visit item_category_path(item.item_category)
    click_link("Ajouter au panier")
  end
end

Given /^There (are|is) "([^"]*)" in the cart"?$/ do |_, item_name|
  given_in_cart(1, item_name)
end

Given /^There are (\d+) "([^"]*)" in the cart"?$/ do |quantity, item_name|
  given_in_cart(quantity.to_i, item_name)
end

When /^I forward the cart to the store account of a valid user$/ do
  fill_in("store[login]", :with => StoreAPI.valid_login)
  fill_in("store[password]", :with => StoreAPI.valid_password)
  click_button("Transférer le panier")
end

When /^I forward the cart to the store account of an invalid user$/ do
  fill_in("store[login]", :with => StoreAPI.invalid_login)
  fill_in("store[password]", :with => StoreAPI.invalid_password)
  click_button("Transférer le panier")
end

Then /^There should be "([^"]*)" in my cart"?$/ do |item_name|
  visit path_to("the cart page")
  response.should contain(item_name)
end
