# Copyright (C) 2011 by Philippe Bourgau

require 'rubygems'
require 'uri'

# Extra URI utilities
module URI

  # extracts the domain from an uri
  def domain

    return "localhost" if scheme == "file"
    return nil if host.nil?
    return nil if host =~ /^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$/

    /([^\.]+\.[^\.]+)$/.match(host)[0]

  end

end
