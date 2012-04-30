# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

# Something to ask if we are online or not
module OfflineTestHelper

  def OfflineTestHelper.ping(server, ping_count)
    system "ping -q -c #{ping_count} #{server}"
  end

  ONLINE = ping('google.com',10)

  # offline and onine predicates
  def offline?
    !online?
  end
  def online?
    ONLINE
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
