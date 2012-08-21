# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

module MesCourses
  module Stores
    module Items

      class Walker

        attr_accessor :categories_digger, :items_digger, :scrap_attributes_block, :father, :index

        def initialize(getter)
          self.categories_digger = NullDigger.new
          self.items_digger = NullDigger.new
          self.scrap_attributes_block = proc do { } end
          @getter = getter
        end

        def title
          @getter.text
        end

        def uri
          page.uri
        end

        def attributes
          @attributes ||= scrap_attributes
        end

        def categories
          categories_digger.sub_walkers(page, self)
        end

        def items
          items_digger.sub_walkers(page, self)
        end

        def to_s
          "#{self.class} ##{index} @#{uri}"
        end

        def genealogy
          genealogy_prefix + to_s
        end

        private
        def page
          @page ||= @getter.get
        end

        def genealogy_prefix
          if father.nil?
            ""
          else
            father.genealogy + "\n"
          end
        end

        def scrap_attributes
          begin
            instance_eval(&@scrap_attributes_block)
          rescue WalkerPageError => e
            raise BrowsingError.new("#{e.message}\n#{genealogy}")
          end
        end
      end
    end
  end
end
