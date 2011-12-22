# Copyright (C) 2011 by Philippe Bourgau

Then /^the place "([^"]*)" should be highlighted$/ do |text|
  response.should highlight_place(text)
end

Then /^the places bar should contain a link "([^"]*)" to (.*)$/ do |text, page|
  response.should have_place(:text => text, :url => path_to(page))
end

