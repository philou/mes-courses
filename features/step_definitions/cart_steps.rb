# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

Given(/^there (are|is) "([^"]*)" in the cart"?$/) do |_, item_name|
  put_item_in_the_cart(1, item_name)
end

Given(/^I have items in my cart$/) do
  item = categorized_item("Marché", "Du jour")
  put_item_in_the_cart(1, item.name)
end

Given(/^I bought the dishes$/) do |table|
  buy_dishes(table)
end

WhenEither(/^I buy (#{CAPTURE_DISH_NAME})$/,
           /^I buy the dishes$/) do |table|
  buy_dishes(table)
end

When(/^I empty the cart$/) do
  empty_the_cart
end

When(/^I transfer my cart to the store$/) do
  transfer_the_cart
end

When(/^I transfer my cart to the store, with account (#{CAPTURE_EMAIL})$/) do |email|
  transfer_the_cart(email)
end

When(/^I try to transfer my cart to the store with wrong identifiers$/) do
  try_to_transfer_the_cart_with_wrong_identifiers
end

When(/^I try transfer my cart to the store, with wrong account (#{CAPTURE_EMAIL})$/) do |email|
  try_to_transfer_the_cart_with_wrong_identifiers(email)
end

When(/^I start to transfer my cart to #{CAPTURE_STORE_NAME}$/) do
  enter_store_account_identifiers
  start_transfering_the_cart
end

When(/^no items have yet actually been transfered to #{CAPTURE_STORE_NAME}$/) do
  wait_while_no_items_are_transfered
  refresh_page
  current_route_should_be(:order_path, /\d+/)
end

When(/^items are actually being transfered to #{CAPTURE_STORE_NAME}$/) do
  start_the_transfer_thread
  refresh_page
  current_route_should_be(:order_path, /\d+/)
end


When(/^all items have actually been transfered to #{CAPTURE_STORE_NAME}$/) do
  join_the_transfer_thread
  refresh_page
  current_route_should_be(:order_logout_path, /\d+/)
end

When(/^the transfer is completely finished$/) do
  refresh_page
  current_route_should_be(:order_login_path, /\d+/)
end

ThenEither(/^the cart should contain (#{CAPTURE_ITEM_NAME})$/,
           /^the cart should contain the items$/) do |table|
  the_cart_should_contain_items(table)
end

Then(/^the cart should not contain any item$/) do
  the_cart_should_not_contain_any_item
end

Then(/^the cart should not contain any dish$/) do
  the_cart_should_not_contain_any_dish
end

ThenEither(/^the cart should contain (#{CAPTURE_DISH_NAME})$/,
           /^the cart should contain the dishes$/) do |table|
  the_cart_should_contain_dishes(table)
end

Then(/^the cart should amount to (#{CAPTURE_AMOUNT})$/) do |price|
  the_cart_should_amount_to(price)
end

Then(/^I should get a confirmation that I bought (#{CAPTURE_ITEM_NAME})$/) do |item_name|
  there_should_be_a_buying_confirmation(item_name)
end
Then(/^I should get a confirmation that I bought (#{CAPTURE_DISH_NAME})$/) do |dish_name|
  there_should_be_a_buying_confirmation(dish_name)
end

Then(/^I should see that between (#{CAPTURE_PERCENTAGE}) and (#{CAPTURE_PERCENTAGE}) of the cart have been transfered to (#{CAPTURE_STORE_NAME})$/) do |min_progress, max_progress, store_name|
  the_transfer_should_be_ongoing(to: store_name, min_progress: min_progress, max_progress: max_progress)
end

Then(/^the client should be automaticaly logged out from (#{CAPTURE_STORE_NAME})$/) do |store_name|
  the_client_should_be_automaticaly_logged_out_from(store_name)
end

Then(/^there should be a button to log into (#{CAPTURE_STORE_NAME}) in a new tab$/) do |store_name|
  there_should_be_a_button_to_a_new_tab_to_log_into(store_name)
end
