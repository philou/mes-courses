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


