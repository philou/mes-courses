# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

Then /^the place "([^"]*)" should be highlighted$/ do |text|
  body.should highlight_place(text)
end

Then /^the places bar should contain a link "([^"]*)" to (.*)$/ do |text, page|
  body.should have_place(:text => text, :url => path_to(page))
end

