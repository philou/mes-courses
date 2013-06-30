# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'cucumber/rspec/doubles'

Given /^the "([^"]*)" store"?$/ do |store_site|
  given_the_store(store_site)
end

Given /^"([^"]*)" are unavailable in the store"?$/ do |item_name|
  given_an_item_is_unavailable_in_the_store(item_name)
end

Then /^an empty cart should be created in the store account of the user$/ do
  then_an_empty_cart_should_be_created_in_the_store_account_of_the_user
end

Then /^a non empty cart should be created in the store account of the user$/ do
  then_a_non_empty_cart_should_be_created_in_the_store_account_of_the_user
end


