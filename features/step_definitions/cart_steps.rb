# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

Given /^there (are|is) "([^"]*)" in the cart"?$/ do |_, item_name|
  put_in_the_cart(1, item_name)
end

Given /^there are (\d+) "([^"]*)" in the cart"?$/ do |quantity, item_name|
  put_in_the_cart(quantity.to_i, item_name)
end

When /^I transfer my cart to the store$/ do
  enter_valid_store_account_identifiers
  start_transfering_the_cart
  wait_for_the_transfer_to_end
end

When /^I try to transfer my cart to the store with wrong identifiers$/ do
  enter_invalid_store_account_identifiers
  start_transfering_the_cart
  wait_for_the_transfer_to_end
end

When /^I start to transfer my cart to the store$/ do
  enter_valid_store_account_identifiers
  start_transfering_the_cart
end

When(/^items are being transfered$/) do
end

When(/^all items have been transfered$/) do
  wait_for_the_transfer_to_end
end

Then /^there should be "([^"]*)" in my cart"?$/ do |item_name|
  the_cart_should_contain(item_name)
end

Then(/^the transfer to "([^"]*)" should be ongoing$/) do |store_name|
  the_transfer_should_be_ongoing_to(store_name)
end

Then(/^the client should be automaticaly logged out from "([^"]*)"$/) do |store_name|
  the_client_should_be_automaticaly_logged_out_from(store_name)
end

Then(/^there should be a button to log into "([^"]*)"$/) do |store_name|
  there_should_be_a_button_to_log_into(store_name)
end
