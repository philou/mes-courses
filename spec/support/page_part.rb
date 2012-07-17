# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class PagePart
  def initialize(description, xpath, parent = nil)
    @xpath = xpath
    @description = description
    @parent = parent
  end

  attr_reader :parent, :description, :xpath

  def has_parent
    !parent.nil?
  end

  def long_description
    "#{description} (#{xpath})"
  end

  def with(description, xpath)
    PagePart.new(description, self.xpath+xpath, self)
  end
  def that(description, xpath)
    PagePart.new("#{self.description} that #{description}", self.xpath+xpath, self)
  end

end
