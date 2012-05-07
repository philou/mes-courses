# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'net/ping'

# Something to ask if we are online or not
module OfflineTestHelper

  # offline and onine predicates
  def offline?
    !online?
  end
  def online?
    @online ||= Net::Ping::TCP.new('www.google.com', 'http').ping?
  end

  # puts a colored warning if offline, otherwise
  def when_online(description)
    if offline?
      puts yellow("WARNING: skipping #{description} because running offline")
    else
      yield
    end
  end

  # something to color text
  def yellow(text)
    "\x1B[33m#{text}\x1B[0m"
  end

end
