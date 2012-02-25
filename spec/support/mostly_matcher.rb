# -*- encoding: utf-8 -*-
# Copyright (C) 2010 by Philippe Bourgau

# Matcher to verify that most items match something else
Spec::Matchers.define :mostly do |item_matcher|
  match do |actual_items|
    if item_matcher.respond_to?(:in)
      item_matcher.in(actual_items)
    end

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
