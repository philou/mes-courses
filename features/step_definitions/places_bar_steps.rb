# Copyright (C) 2011 by Philippe Bourgau

Then /^the body id should be "([^"]*)"$/ do |body_id|
  response.should have_body_id(body_id)
end

Then /^the places bar should contain a link "([^"]*)" to (.*)$/ do |text, page|
#  response.should have_xpath("//div[@id='places']/a[text()='#{text}'][contains(@href,'#{path_to(page)}')]")
  response.should have_place(:text => text, :url => path_to(page))
end

