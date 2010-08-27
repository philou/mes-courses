require 'spec/models/store_spec_helper'
require 'ping'

OFFLINE = !Ping.pingecho('http://www.google.com')
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
