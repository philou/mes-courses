# Copyright (C) 2011 by Philippe Bourgau

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require 'webrat/core/locators/link_locator'

Then /^The path bar should contain "([^\"]*)"$/ do |text|
  response.should have_xpath("//div[@id='path-bar']/a[text()='#{text}']")
end

Then /^The path bar should contain a link "([^\"]*)" to (.+ page)$/ do |text, page_name|
  response.should have_xpath("//div[@id='path-bar']/a[@href='#{path_to(page_name, request)}'][text()='#{text}']")
end


