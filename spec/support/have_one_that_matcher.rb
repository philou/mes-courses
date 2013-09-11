# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

# Matcher to verify that at least one item match something else
RSpec::Matchers.define :have_one_that do |item_matcher|

  match do |actual_items|
    actual_items.any? { |item| item_matcher.matches?(item)}
  end

  description do
    "#{item_matcher.description} to be true for at least one item"
  end

end
