# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

# Matcher to verify that at least one item match something else
RSpec::Matchers.define :and_ do |*matchers|

  match do |actual|
    matchers.all? {|matcher| matcher.matches?(actual) }
  end

  description do
    (matchers.map &:description).join(" and ")
  end

end
