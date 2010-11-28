# Copyright (C) 2010 by Philippe Bourgau

require 'spec/models/store_scrapping_test_strategy'
require 'spec/mostly_matcher'
require 'spec/all_matcher'
require 'spec/have_non_nil_matcher'
require 'lib/deep_clone'
require 'ping'

# something to color text
def yellow(text)
  "\x1B[33m#{text}\x1B[0m"
end

# Something to ask if we are online or not
OFFLINE = !Ping.pingecho('google.com',1,80)
if OFFLINE
  puts yellow("WARNING: testing in offline mode")
end
module OfflineOrNot
  def offline?
    OFFLINE
  end
end
World(OfflineOrNot)

# Enable factory girl
Before do
  require 'factory_girl'
  Dir.glob(File.join(File.dirname(__FILE__), '../spec/factories/*.rb')).each { |f| require f }
end

