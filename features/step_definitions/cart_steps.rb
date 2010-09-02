# Copyright (C) 2010 by Philippe Bourgau


Then /^There should be "([^"]*)" in my cart$/ do |item_name|
  visit path_to("the cart page")
  response.should contain(item_name)
end
