# Copyright (C) 2010 by Philippe Bourgau

require 'spec/models/store_spec_helper'
require 'ping'

OFFLINE = !Ping.pingecho('google.com',1,80)
if OFFLINE
  puts "WARNING: testing in offline mode"
end
module OfflineOrNot
  def offline?
    OFFLINE
  end
end
World(OfflineOrNot)

World(StoreSpecHelper)
