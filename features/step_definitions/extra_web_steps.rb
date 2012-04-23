# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require 'webrat/core/locators/link_locator'
require 'string_extras'

Given /^(?:|I )tried to go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

When /^(?:|I )try to go to (.+)$/ do |page_name|
  visit path_to(page_name)
end

Then /^I should see a link "([^\"]*)" to "([^\"]*)"$/ do |text, url|
  page.should have_xpath("//a[@href='#{url}'][contains(.,'#{text}')]")
end

Then /^I should see a button "([^\"]*)" to "([^\"]*)"$/ do |text, url|
  page.should have_xpath("//form[@action='#{url}']//input[@type='submit'][@value='#{text}']")
end

Then /^the "([^"]*)" field of the "([^"]*)" should be "([^"]*)""?$/ do |field, form, value|
  page.should have_xpath("//form[@id='#{form}']/input[@name='#{form}[#{field}]'][@value='#{value}']")
end

Then /^the page should auto refresh$/ do
  page.should have_xpath("//meta[@http-equiv='refresh']")
end

Then /^I should be redirected to (.+)$/ do |page_name|
  [301,302].should include(@integration_session.status)
  location = @integration_session.headers["Location"]
  location.should be_starting_with(path_to(page_name))
  visit location
end

Then /^there should be an iframe with id "([^"]*)" and url "([^"]*)"$/ do |id, url|
  page.should have_xpath("//iframe[@id='#{id}'][@src='#{url}']")
end
