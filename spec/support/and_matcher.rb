# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

# Matcher to verify that an item matches all matchers in a list
RSpec::Matchers.define :and_ do |*matchers|

  match do |actual|
    matchers.all? {|matcher| matcher.matches?(actual) }
  end

  description do
    (matchers.map &:description).join(" and ")
  end

end
