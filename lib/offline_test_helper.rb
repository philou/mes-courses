# Copyright (C) 2011 by Philippe Bourgau

require 'ping'

# Something to ask if we are online or not

module OfflineTestHelper

  ONLINE = Ping.pingecho('google.com',10,80)

  # offline and onine predicates
  def offline?
    !online?
  end
  def online?
    ONLINE
  end

  # puts a colored warning if offline
  def warn_if_offline
    if offline?
      puts yellow("WARNING: testing in offline mode")
    end
  end

  # something to color text
  def yellow(text)
    "\x1B[33m#{text}\x1B[0m"
  end

end
