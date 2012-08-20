# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

class Digger
  def initialize(selector, factory)
    @selector = selector
    @factory = factory
  end

  def sub_walkers(page, father)
    page.search_links(@selector).each_with_index.map { |link, i| @factory.new(link, father, i) }
  end
end
