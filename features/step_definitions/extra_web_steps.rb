# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require 'webrat/core/locators/link_locator'

Then /^"([^\"]*)" should link to (.+ page)$/ do |link_text, page_name|
  find_link_href(link_text).should == path_to(page_name)
end

Then /^I should see a button "([^\"]*)" to "([^\"]*)"$/ do |text, url|
  response.should have_xpath("//form[@action='#{url}']//input[@type='submit'][@value='#{text}']")
end

Then /^the "([^"]*)" field of the "([^"]*)" should be "([^"]*)"$/ do |field, form, value|
  response.should have_xpath("//form[@id='#{form}']/input[@name='#{form}[#{field}]'][@value='#{value}']")
end
