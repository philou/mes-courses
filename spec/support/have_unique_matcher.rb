# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

# Matcher to verify that a hash's key is unique in a collection of other hashes
# a full class is required to implement the in method
# Use like: hash.should have_unique(:id).in(hashes)
class HaveUnique

  def initialize(key)
    @key = key
  end

  def in(collection)
    @collection = collection
    @index = Hash.new(0)
    collection.each do |item|
      @index[item[@key]] += 1
    end
    self
  end

  def matches?(actual)
    @actual = actual
    @index[actual[@key]] == 1
  end

  def failure_message_for_should
    "expected #{actual}[#{@key}] (=#{actual[key]}) to be unique in #{@collection}"
  end

  def description
    "expected an hash with a unique #{key} in #{@collection}"
  end
end

def have_unique(key)
  HaveUnique.new(key)
end

