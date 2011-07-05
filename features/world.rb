# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec/models/store_importing_test_strategy'
require 'spec/support/constants'
require 'spec/support/mostly_matcher'
require 'spec/support/all_matcher'
require 'spec/support/have_non_nil_matcher'
require 'spec/stubs/cucumber'

module LinkLocator
  def find_link_href(text)
    n = Nokogiri::HTML(response.body)
    n.xpath("//a[contains(.,\"#{text}\")]").first['href']
  end
end
World(LinkLocator)
