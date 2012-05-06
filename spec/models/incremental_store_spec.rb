# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe IncrementalStore do

  before(:each) do
    @store = mock_model(Store).as_null_object
    @store.stub(:known_item_category).and_return(nil)
    @store.stub(:known_item).and_return(nil)
    @store.stub(:delete_empty_item_categories).and_return(0)
    @i_store = IncrementalStore.new(@store)

    ItemCategory.stub(:root).and_return(ItemCategory.new(:name => ItemCategory::ROOT_NAME))
  end

  context "when starting import" do
    it "should mark existing items from the store when starting import" do
      @store.should_receive(:mark_existing_items)
      @i_store.starting_import
    end

    it "should check if there are visited urls to know if the last import finished" do
      finished = true
      @store.should_receive(:are_there_visited_urls?).and_return(finished)
      @i_store.last_import_finished?.should == !finished
    end
  end

  context "when finishing import" do
    after(:each) do
      @i_store.finishing_import
    end

    it "should delete sold out items from the store" do
      @store.should_receive(:delete_sold_out_items)
    end
    it "should delete empty item categories" do
      @store.should_receive(:delete_empty_item_categories).once.and_return(0)
    end
    it "should delete categories until no more are empty" do
      @store.should_receive(:delete_empty_item_categories).twice.and_return(1,0)
    end
    it "should delete visited urls" do
      @store.should_receive(:delete_visited_urls)
    end

    it "should not send an email if no dish are broken" do
      @store.stub(:find_sold_out_items).and_return([FactoryGirl.create(:item)])

      BrokenDishesReporter.should_not_receive(:email)
    end

    context "when there are broken dishes" do
      before :each do
        @dish_breaking_items = [FactoryGirl.create(:item), FactoryGirl.create(:item)]
        @dish_breaking_items.each do |item|
          item.dishes = [FactoryGirl.create(:dish)]
        end
        items = @dish_breaking_items + [FactoryGirl.create(:item)]
        @store.stub(:find_sold_out_items).and_return(items)
      end

      it "should send an email with broken dishes" do
        BrokenDishesReporter.should_receive(:email).with(@dish_breaking_items).and_return(email = stub("Email"))
        email.should_receive(:deliver)
      end

      it "should fix broken dishes" do
        @dish_breaking_items.each do |item|
          item.dishes.each do |dish|
            dish.items.should_receive(:delete).with(item).ordered
            dish.should_receive(:save!).ordered
          end
        end
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

    ItemCategory.should_receive(:new).with(argument.merge(:parent => ItemCategory.root)).and_return(new_record)
    @store.should_receive(:register!).with(new_record)

    result = @i_store.register_item_category(argument)

    result.should be(new_record)
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
      @store.should_receive(:already_visited_url?).with(@url).and_return(visited)
      @i_store.already_visited_url?(@url).should be(visited)
    end

    it "should register visited urls to its store" do
      @store.should_receive(:register_visited_url).with(@url)
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
      @known_item.should_receive(:equal_to_attributes?).with(@attributes).and_return(false)
      @i_store.register_item(@attributes)
    end

    context "that did not change" do
      it "should not register any item" do
        @store.should_not_receive(:register!)
        @i_store.register_item(@attributes)
      end

      it "should return the known item" do
        known_item = @i_store.register_item(@attributes)
        known_item.should be_an(Item)
        known_item.name.should == @attributes[:name]
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
        @known_item.should_receive(:attributes=).with(@attributes)
        @i_store.register_item(@attributes)
      end

      it "should register the modified item" do
        @store.should_receive(:register!).with(@known_item)
        @i_store.register_item(@attributes)
      end

      it "should return the updated item" do
        @i_store.register_item(@attributes).should == @known_item
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

    @store.should_not_receive(:register!)

    @i_store.register_item_category(attributes)
  end

  private
  def should_register_in_store(message, argument, recordType)
    new_record = recordType.new

    recordType.should_receive(:new).with(argument).and_return(new_record)
    @store.should_receive(:register!).with(new_record)

    result = @i_store.send(message, argument)

    result.should be(new_record)
  end

  def should_tell_the_store_that_item_is_not_sold_out(item_hash)
    @store.should_receive(:mark_not_sold_out).with(instance_of(Item))
    @i_store.register_item(item_hash)
  end

end
