# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
require 'webrat/core/locators/link_locator'

Then /^"([^\"]*)" should link to (.+ page)$/ do |link_text, page_name|
  find_link_href(link_text).should == path_to(page_name)
end

Then /^"([^\"]*)" should link to the "([^\"]*)" website$/ do |link_text, website_host|
  URI.parse(find_link_href(link_text)).host.should == website_host
end
