# -*- encoding: utf-8 -*-
# Copyright (C) 2012 by Philippe Bourgau

class PagePart
  def initialize(xpath, description, parent = nil)
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

  def with(xpath, description)
    PagePart.new(self.xpath+xpath, "#{self.description} with #{description}", self)
  end
  def that(xpath, description)
    PagePart.new(self.xpath+xpath, "#{self.description} (that #{description})", self)
  end

end
