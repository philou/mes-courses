# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

module MesCourses
  module Stores
    module Items

      class ApiBuilder

        def self.define(api_class, digger_class, &block)
          new(api_class, digger_class).tap do |result|
            result.instance_eval(&block)
          end
        end

        def initialize(api_class, digger_class)
          @api_class = api_class
          @digger_class = digger_class
          @scrap_attributes_block = lambda do {} end
          @categories_digger = NullDigger.new
          @items_digger = NullDigger.new
        end

        def attributes(&block)
          @scrap_attributes_block = block
        end

        def categories(selector, &block)
          @categories_digger = @digger_class.new(selector, ApiBuilder.define(@api_class, @digger_class, &block))
        end

        def items(selector, &block)
          @items_digger = @digger_class.new(selector, ApiBuilder.define(@api_class, @digger_class, &block))
        end

        def new(page_getter, father = nil, index = nil)
          @api_class.new(page_getter).tap do |result|
            result.categories_digger = @categories_digger
            result.items_digger = @items_digger
            result.scrap_attributes_block = @scrap_attributes_block
            result.father = father
            result.index = index
          end
        end
      end

      def self.define_api(name, &block)
        builder = ApiBuilder.define(Walker, Digger, &block)

        Api.register_builder(name, builder)
      end
    end
  end
end
