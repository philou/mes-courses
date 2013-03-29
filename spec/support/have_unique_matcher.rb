# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2013 by Philippe Bourgau

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
      @index[value(item)] += 1
    end
    self
  end

  def matches?(actual)
    @actual = actual
    @index[value(actual)] == 1
  end

  def failure_message_for_should
    "expected #{value_expression(actual)} (=#{value(actual)}) to be unique in #{@collection}"
  end

  def description
    "expected an hash or object with a unique #{@key} in #{@collection}"
  end

  private
  def value(actual)
    if actual.instance_of?(Hash)
      actual[@key]
    else
      actual.send(@key)
    end
  end
  def value_expression(actual)
    if actual.instance_of?(Hash)
      "#{actual}[#{@key}]"
    else
      "#{actual}.#{@key}"
    end
  end
end

def have_unique(key)
  HaveUnique.new(key)
end

