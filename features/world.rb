# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec/models/store_importing_test_strategy'
require 'spec/mostly_matcher'
require 'spec/all_matcher'
require 'spec/have_non_nil_matcher'
require 'spec/stubs/cucumber'
require 'lib/deep_clone'
require 'lib/offline_test_helper'

include OfflineTestHelper
warn_if_offline

World(OfflineTestHelper)

module LinkLocator
  def find_link_href(text)
    n = Nokogiri::HTML(response.body)
    n.xpath("//a[contains(.,\"#{text}\")]").first['href']
  end
end
World(LinkLocator)
