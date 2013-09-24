# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012, 2013 by Philippe Bourgau

# Matcher to verify that most items match something else
RSpec::Matchers.define :mostly do |item_matcher|
  match do |actual_items|
    expected_uniques_count(actual_items) <= actual_matches(actual_items, item_matcher).length
  end
  description do
    "#{item_matcher.description} to be true for at least 70% of the items"
  end

  #private

  def expected_uniques_count(actual_items)
    (actual_items.length * 0.7).round
  end
  def actual_matches(actual_items, item_matcher)
    actual_items.find_all {|item| item_matcher.matches?(item)}
  end

end
