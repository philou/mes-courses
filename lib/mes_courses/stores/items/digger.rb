# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

module MesCourses
  module Stores
    module Items
      class Digger
        def initialize(selector, factory)
          @selector = selector
          @factory = factory
        end

        def sub_walkers(page, father)
          page.search_links(@selector).each_with_index.to_a.mapping do |link, i|
            @factory.new(link, father, i)
          end
        end
      end
    end
  end
end
