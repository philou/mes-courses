# -*- encoding: utf-8 -*-
# Copyright (C) 2014 by Philippe Bourgau

require "webrick/httputils"

# monkey patch to avoid a regex uri encoding error when importing
#      incompatible encoding regexp match (ASCII-8BIT regexp with UTF-8 string) (Encoding::CompatibilityError)
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:353:in `gsub'
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:353:in `_escape'
#      /home/philou/.rbenv/versions/1.9.3-p194/lib/ruby/1.9.1/webrick/httputils.rb:363:in `escape'
#      from uri method
module WEBrick::HTTPUtils
  def self.escape(s)
    URI.escape(s)
  end
end
