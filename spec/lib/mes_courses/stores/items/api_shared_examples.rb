# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Items

      module ApiSpecMacros

        def self.included(base)
          base.send :extend, ClassMethods
        end

        module ClassMethods

          def it_should_behave_like_any_store_items_api

            before :all do
              @range = 0..1
            end

            it "should have many item categories" do
              @store.categories.should have_at_least(3).items
            end

            it "should have many items" do
              sample_items.should have_at_least(3).items
            end

            it "should have item categories with different names" do
              categories_attributes = @store.categories.map { |cat| cat.attributes }
              categories_attributes.should mostly have_unique(:name)
            end

            it "should have items with different summaries" do
              sample_items_attributes.should mostly have_unique(:summary)
            end

            it "should have parseable item category attributes" do
              parseable_categories_attributes.should mostly have_key(:name)
            end

            it "should have valid item category attributes" do
              parseable_categories_attributes.each do |attributes|
                ItemCategory.new(attributes)
              end
            end

            it "should have some valid item attributes" do
              sample_items_attributes.should_not be_empty
            end

            it "should have items with a price" do
              sample_items_attributes.should all_do have_key(:price)
            end

            it "should mostly have items with an image" do
              sample_items_attributes.should mostly have_key(:image)
            end

            it "should mostly have items with a summary" do
              sample_items_attributes.should mostly have_key(:summary)
            end

            it "should have items with unique remote id" do
              sample_items_attributes.should all_do have_unique(:remote_id)
            end

            it "should have items with unique uris" do
              valid_sample_items.should all_do have_unique(:uri)
            end
          end
        end


        def collect_all(categories, message)
          categories.map { |cat| cat.send(message).to_a[@range] }.flatten
        end

        def sample_categories
          @store.categories.to_a[@range]
        end
        def sample_sub_categories
          collect_all(sample_categories, :categories)
        end
        def all_sample_categories
          sample_categories + sample_sub_categories
        end
        def sample_items
          collect_all(all_sample_categories, :items)
        end
        def valid_sample_items
          valid_items(sample_items)
        end
        def sample_items_attributes
          (valid_sample_items.map &:attributes).uniq
        end

        def valid_items(items)
          result = []
          sample_items.each do |item|
            begin
              item.attributes
              result.push(item)
            rescue BrowsingError => e
              Rails.logger.debug e.message
            end
          end
          result
        end

        def parseable_categories_attributes
          all_sample_categories.map do |category|
            category.attributes rescue {}
          end
        end

      end
    end
  end
end
