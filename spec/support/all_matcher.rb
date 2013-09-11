# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

# Matcher to verify that all items match something else
RSpec::Matchers.define :all_ do |item_matcher|

  match do |actual_items|
    if item_matcher.respond_to?(:in)
      item_matcher.in(actual_items)
    end

    actual_items.all? { |item| item_matcher.matches?(item)}
  end

  description do
    "#{item_matcher.description} to be true for all the items"
  end

end