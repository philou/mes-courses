# Copyright (C) 2010 by Philippe Bourgau

require 'spec/models/scrapper_spec_helper'
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

World(ScrapperSpecHelper)
