# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

# Matcher to verify that many elements are present in a collection
RSpec::Matchers.define :include_all do |required_items|
  match do |actual|
    include_all?(actual,required_items)
  end
  failure_message_for_should do |actual|
    "#{missing_items(actual,required_items).inspect} are missing"
  end
  failure_message_for_should_not do |actual|
    "at least one element of #{required_items} should be absent"
  end
  description do
    "expected a collection containing all elements from #{required_items}"
  end

  #private

  def include_all?(collection,required_items)
    missing_items(collection, required_items).empty?
  end

  def missing_items(collection, required_items)
    result = []
    required_items.each do |item|
      if !collection.include?(item)
        result.push(item)
      end
    end
    result
  end

end

