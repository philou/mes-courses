# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'
require "mes_courses/stores/items/real_dummy_api"
require_relative "real_dummy_generator"

module MesCourses
  module Stores
    module Items

      describe "RealDummyApi", slow: true do
        include ApiSpecMacros

        it_should_behave_like_any_store_items_api

        before :each do
          generate_store
        end

        def generate_store(item_count = 3)
          RealDummy.wipe_out
          RealDummy.open(store_name = "www.spec-store.com").generate(3).categories.and(3).categories.and(item_count).items
          @store = Api.browse(RealDummy.uri(store_name))
        end

        it "should use constant memory" do
          heat_up_measure = memory_usage_for_items(1)

          small_inputs_memory = memory_usage_for_items(1)
          large_inputs_memory = memory_usage_for_items(200)

          large_inputs_memory.should be <= small_inputs_memory * 1.05
        end

        def memory_usage_for_items(item_count)
          generate_store(item_count)
          memory_peak_of do
            walk_store
          end
        end

        def memory_peak_of
          peak_usage = 0
          finished = false

          initial_usage = current_living_objects
          profiler = Thread.new do
            while not finished
              peak_usage = [peak_usage, current_living_objects].max
              sleep(0.01)
            end
          end

          yield

          finished = true
          profiler.join

          peak_usage - initial_usage
        end

        def current_living_objects
          GC.start
          object_counts = ObjectSpace.count_objects
          object_counts[:TOTAL] - object_counts[:FREE]
        end

        def walk_store
          @store.categories.each do |category|
            @title = category.title
            @attributes = category.attributes
            category.categories.each do |sub_category|
              @title = sub_category.title
              @attributes = sub_category.attributes
              category.items.each do |item|
                @title = item.title
                @attributes = item.attributes
              end
            end
          end
        end
      end
    end
  end
end
