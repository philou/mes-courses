# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012 by Philippe Bourgau

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require 'webrat/core/locators/link_locator'

Given /^(?:|I )am on (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  page.should have_content(text)
end

Then /^(?:|I )should not see "([^"]*)"$/ do |text|
  page.should_not have_content(text)
end

Then /^(?:|I )should be on (.+)$/ do |page_name|
  current_path = URI.parse(current_url).path
  current_path.should == path_to(page_name)
end

Then /^I should see a link "([^\"]*)" to "([^\"]*)"$/ do |text, url|
  page.should have_xpath("//a[@href='#{url}'][contains(.,'#{text}')]")
end

Then /^the "([^"]*)" field of the "([^"]*)" should be "([^"]*)""?$/ do |field, form, value|
  page.should have_xpath("//form[@id='#{form}']/input[@name='#{form}[#{field}]'][@value='#{value}']")
end

Then /^the page should auto refresh$/ do
  page.should have_xpath("//meta[@http-equiv='refresh']")
end

Then /^there should be an iframe with id "([^"]*)" and url "([^"]*)"$/ do |id, url|
  page.should have_xpath("//iframe[@id='#{id}'][@src='#{url}']")
end
