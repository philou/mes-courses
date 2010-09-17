# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

# Matcher to verify that items names are mostly unique
Spec::Matchers.define :have_mostly_different do |attribute|
  match do |actual_items|
    expected_uniques_count(actual_items) <= actual_uniques(actual_items, attribute).length
  end
  description do
    "expected a collection containing items with mostly unique #{attribute}"
  end

  #private

  def expected_uniques_count(actual_items)
    (actual_items.length * 0.7).round
  end
  def actual_uniques(actual_items, attribute)
    Set.new(actual_items.map {|item| item[attribute]})
  end

end

