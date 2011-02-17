# Copyright (C) 2011 by Philippe Bourgau

require 'ping'

# Something to ask if we are online or not

module OfflineTestHelper

  OFFLINE = !Ping.pingecho('google.com',1,80)

  # offline and onine predicates
  def offline?
    OFFLINE
  end
  def online?
    !offline?
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
