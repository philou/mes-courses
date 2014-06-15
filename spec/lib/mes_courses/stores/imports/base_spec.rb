# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau
# http://philippe.bourgau.net

# This file is part of mes-courses.

# mes-courses is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.


require 'spec_helper'

module MesCourses
  module Stores
    module Imports

      describe Base do

        before :each do
          @importer = Base.new()

          @store = double("Store").as_null_object
          @store.stub(:already_visited_url?).and_return(false)
        end

        def given_a_store_with_root_categories
          bind(stub_api(categories: Array.new(2) {stub_category}))
        end

        def given_a_store_with_sub_categories
          bind(stub_api(
                        categories: [stub_category(
                                                   categories: Array.new(2) {stub_category})]))
        end

        def given_a_store_with_items
          bind(stub_api(
                        categories: [stub_category(
                                                   categories: [stub_category(
                                                                              items: Array.new(2) {stub_item})])]))
        end

        def given_a_store_with_one_item
          bind(stub_api(
                        categories: [stub_category(
                                                   categories: [stub_category(
                                                                              items: [stub_item])])]))
        end

        def import
          @importer.import(@store_api, @store)
        end

        def bind(store_api)
          @store_api = store_api
          @root_categories = @store_api.categories
          unless @root_categories.empty?
            @root_category = @root_categories.first
            @sub_categories = @root_category.categories

            unless @sub_categories.empty?
              @sub_category = @sub_categories.first
              @items = @sub_category.items

              unless @items.empty?
                @item = @items.first
              end
            end
          end
        end

        def stub_api(options = {})
          stub_walker("", options)
        end

        def stub_category(options = {})
          stub_walker(FactoryGirl.generate(:category_name), options)
        end

        def stub_item(options = {})
          stub_walker(FactoryGirl.generate(:item_name), FactoryGirl.attributes_for(:item))
        end

        def stub_walker(name, options = {})
          uri = "http://www.story.com/#{name}"
          items = options.delete(:items) || []
          categories = options.delete(:categories) || []
          attributes = options.merge(name: name)

          double("Walker #{uri}", {attributes: attributes, uri: URI.parse(uri), categories: categories, items: items})
        end

        context "when starting from scratch" do

          before :each do
            record_calls(@store, :starting_import, :finishing_import, :register_item_category, :register_item, :register_visited_url)
          end

          def record_calls(stub_object, *selectors)
            @recorded_calls = []
            selectors.each do |selector|
              stub_object.stub(selector) do |*args|
                @recorded_calls.push(selector)
                result(args)
              end
            end
          end
          def result(args)
            if (args.count == 1)
              args.first
            else
              args
            end
          end

          it "should call start_import before registering items" do
            given_a_store_with_items

            expect(@store).to receive(:starting_import).once

            import

            expect(@recorded_calls.first).to eq :starting_import
          end

          it "should call stop_import after registering items" do
            given_a_store_with_items

            expect(@store).to receive(:finishing_import).once

            import

            expect(@recorded_calls.last).to eq :finishing_import
          end

          it "should register item categories for root categories" do
            given_a_store_with_root_categories

            @root_categories.each do |category|
              expect(@store).to receive(:register_item_category).with(category.attributes.merge(:parent => nil))
            end

            import
          end

          it "should register item sub categories" do
            given_a_store_with_sub_categories

            @sub_categories.each do |sub_category|
              expect(@store).to receive(:register_item_category).with(sub_category.attributes.merge(:parent => @root_category.attributes.merge(:parent => nil)))
            end

            import
          end

          it "should register items" do
            given_a_store_with_items

            @items.each do |item|
              expect(@store).to receive(:register_item).with(item.attributes.merge(:item_categories => [@sub_category.attributes.merge(:parent => @root_category.attributes.merge(:parent => nil))]))
            end

            import
          end

          it "should register a visited url for every category" do
            given_a_store_with_root_categories

            it_should_register_visited_urls_for(@root_categories)
          end

          it "should register a visited url for every sub category" do
            given_a_store_with_sub_categories

            it_should_register_visited_urls_for(@sub_categories)
          end

          it "should register a visited url for every item" do
            given_a_store_with_items

            it_should_register_visited_urls_for(@items)
          end

          def it_should_register_visited_urls_for(walkers)
            walkers.each do |walker|
              expect(@store).to receive(:register_visited_url).with(walker.uri.to_s)
            end

            import
          end

          it "should register visited url AFTER the item was registered" do
            given_a_store_with_one_item

            @store.stub(:register_visited_url) do |uri|
              expect(@store).to have_received(:register_item).with(@item.attributes)
            end

            import
          end

        end

        context "when starting after a previous one" do

          before :each do
            given_a_store_with_one_item

            import
          end

          it "should start a new import if the last one finished" do
            @store.stub(:last_import_finished?).and_return(true)
            expect(@store).to receive(:starting_import)

            import
          end

          it "should not start a new import if the last one did not finish" do
            @store.stub(:last_import_finished?).and_return(false)
            expect(@store).not_to receive(:starting_import)

            import
          end

          it "should ask if urls were already visited with string uris" do
            uris = [@store_api.uri, @root_categories.first.uri, @sub_categories.first.uri, @items.first.uri]

            expect(@store).to receive(:already_visited_url?).with(instance_of(String)).exactly(uris.size).and_return(false)

            import
          end

          it "should not register item categories if urls were visited" do
            @store.stub(:already_visited_url?).and_return(true)

            expect(@store).not_to receive(:register_item_category)
            expect(@store).not_to receive(:register_item)

            import
          end

          it "should not register items if urls were visited" do
            @store.stub(:already_visited_url?).with(@item.uri.to_s).and_return(true)

            expect(@store).to receive(:register_item_category).twice
            expect(@store).not_to receive(:register_item)

            import
          end

        end

        context "when handling errors" do

          before :each do
            given_a_store_with_one_item
          end

          it "should let interrupts and other fatal exception climb up the stack" do
            exception_should_climb_up_the_stack(Interrupt)
          end

          it "should let standard errors climb up the stack" do
            exception_should_climb_up_the_stack(SocketError)
          end

          it "should continue on server error" do
            @item.stub(:attributes).and_raise(Mechanize::ResponseCodeError.new(double("Page", code: 500)))

            no_exception_should_climb_up_the_stack
          end

          it "should continue on unimportable store pages" do
            @item.stub(:attributes).and_raise(::Storexplore::BrowsingError.new())

            no_exception_should_climb_up_the_stack
          end

          it "should continue on badly formed store items" do
            @store.stub(:register_item).and_raise(ActiveRecord::RecordInvalid.new(Item.new))

            no_exception_should_climb_up_the_stack
          end

          def exception_should_climb_up_the_stack(exception_class)
            @item.stub(:attributes).and_raise(exception_class.new("Test mock simulated error."))

            expect(lambda { import }).to raise_error(exception_class)
          end

          def no_exception_should_climb_up_the_stack
            expect(lambda { import }).not_to raise_error
          end

        end
      end
    end
  end
end
