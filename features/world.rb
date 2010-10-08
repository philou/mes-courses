# Copyright (C) 2010 by Philippe Bourgau

require 'spec/models/store_scrapper_spec_helper'
require 'spec/mostly_matcher'
require 'spec/all_matcher'
require 'spec/have_non_nil_matcher'
require 'lib/deep_clone'
require 'ping'

def yellow(text)
  "\x1B[33m#{text}\x1B[0m"
end

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

World(StoreScrapperSpecHelper)
