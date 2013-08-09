# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

module MesCourses
  module Stores
    module Imports

      describe Incremental do

        before(:each) do
          @store = mock_model(Store).as_null_object
          @store.stub(:known_item_category).and_return(nil)
          @store.stub(:known_item).and_return(nil)
          @i_store = Incremental.new(@store)

          ItemCategory.stub(:root).and_return(ItemCategory.new(:name => ItemCategory.root_name))
        end

        context "when starting import" do
          it "should mark existing items from the store when starting import" do
            expect(@store).to receive(:mark_existing_items)
            @i_store.starting_import
          end

          it "should check if there are visited urls to know if the last import finished" do
            finished = true
            expect(@store).to receive(:are_there_visited_urls?).and_return(finished)
            expect(@i_store.last_import_finished?).to eq !finished
          end
        end

        context "when finishing import" do
          after(:each) do
            @i_store.finishing_import
          end

          it "should clean up sold out items" do
            expect(@store).to receive(:disable_sold_out_items).ordered
            expect(@store).to receive(:delete_unused_items).ordered
            expect(@store).to receive(:delete_unused_item_categories).ordered
          end

          it "should delete visited urls" do
            expect(@store).to receive(:delete_visited_urls)
          end

          it "should not send an email if no dish are broken" do
            @store.stub(:find_sold_out_items).and_return([FactoryGirl.build_stubbed(:item_with_categories)])

            expect(BrokenDishesReporter).not_to receive(:email)
          end

          context "when there are broken dishes" do
            before :each do
              @dish_breaking_items = Array.new(2){ FactoryGirl.create(:item_with_categories, dishes: [FactoryGirl.create(:dish_with_items)] ) }
              items = @dish_breaking_items + [FactoryGirl.create(:item_with_categories)]
              @store.stub(:find_sold_out_items).and_return(items)
            end

            it "should send an email with broken dishes" do
              expect(BrokenDishesReporter).to receive(:email).with(@dish_breaking_items).and_return(email = double("Email"))
              expect(email).to receive(:deliver)
            end

          end

        end

        it "should register found item categories to its store" do
          parent_category = stub_model(ItemCategory, :name => "A big category")
          should_register_in_store(:register_item_category, {:parent => parent_category}, ItemCategory)
        end
        it "should register item categories with no parent to its store under the root category" do
          argument = {:parent => nil}
          new_record = ItemCategory.new

          expect(ItemCategory).to receive(:new).with(argument.merge(:parent => ItemCategory.root)).and_return(new_record)
          expect(@store).to receive(:register!).with(new_record)

          result = @i_store.register_item_category(argument)

          expect(result).to be(new_record)
        end
        it "should register found items to its store" do
          should_register_in_store(:register_item, {}, Item)
        end

        it "should tell the store that new items are not sold out" do
          should_tell_the_store_that_item_is_not_sold_out({})
        end

        context "when resuming previous import" do
          before(:each) do
            @url = "http://www.store.com/Viandes/Boeuf/Bavette"
          end

          it "should ask to its store if an url was already visited" do
            visited = true
            expect(@store).to receive(:already_visited_url?).with(@url).and_return(visited)
            expect(@i_store.already_visited_url?(@url)).to be(visited)
          end

          it "should register visited urls to its store" do
            expect(@store).to receive(:register_visited_url).with(@url)
            @i_store.register_visited_url(@url)
          end
        end

        context "when importing known items" do
          before(:each) do
            @attributes = {:name => "Truite", :price => 2.4, :remote_id => 123}
            @known_item = Item.new(@attributes)
            @store.stub(:known_item).with(@attributes[:remote_id]).and_return(@known_item)
          end

          it "should check if the item has changed" do
            expect(@known_item).to receive(:equal_to_attributes?).with(@attributes).and_return(false)
            @i_store.register_item(@attributes)
          end

          context "that did not change" do
            it "should not register any item" do
              expect(@store).not_to receive(:register!)
              @i_store.register_item(@attributes)
            end

            it "should return the known item" do
              known_item = @i_store.register_item(@attributes)
              expect(known_item).to be_an(Item)
              expect(known_item.name).to eq @attributes[:name]
            end

            it "should tell the store that new items are not sold out" do
              should_tell_the_store_that_item_is_not_sold_out(@attributes)
            end
          end
          context "that have changed" do
            before(:each) do
              @attributes[:price] = 2.1
            end

            it "should update the item" do
              expect(@known_item).to receive(:attributes=).with(@attributes)
              @i_store.register_item(@attributes)
            end

            it "should register the modified item" do
              expect(@store).to receive(:register!).with(@known_item)
              @i_store.register_item(@attributes)
            end

            it "should return the updated item" do
              expect(@i_store.register_item(@attributes)).to eq @known_item
            end

            it "should tell the store that new items are not sold out" do
              should_tell_the_store_that_item_is_not_sold_out(@attributes)
            end
          end
        end

        it "should not register known item categories" do
          name = "Boeuf"
          attributes = {:name => name}
          known_item_category = ItemCategory.new(attributes)
          @store.stub(:known_item_category).with(name).and_return(known_item_category)
          known_item_category.stub(:equal_to_attributes?).and_return(true)

          expect(@store).not_to receive(:register!)

          @i_store.register_item_category(attributes)
        end

        private
        def should_register_in_store(message, argument, recordType)
          new_record = recordType.new

          expect(recordType).to receive(:new).with(argument).and_return(new_record)
          expect(@store).to receive(:register!).with(new_record)

          result = @i_store.send(message, argument)

          expect(result).to be(new_record)
        end

        def should_tell_the_store_that_item_is_not_sold_out(item_hash)
          expect(@store).to receive(:mark_not_sold_out).with(instance_of(Item))
          @i_store.register_item(item_hash)
        end

      end
    end
  end
end
