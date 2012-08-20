# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe StoreImporter do

  before :each do
    @importer = StoreImporter.new()

    @store = stub("Store").as_null_object
    @store.stub(:already_visited_url?).and_return(false)
  end

  def import
    @importer.import(@store_api, @store)
  end

  def given_a_store_with(root_categories)
    @store_api = MesCourses::Stores::Items::DummyApi.new_custom_store(root_categories)

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

  def given_a_store_with_root_categories
    given_a_store_with [{:name => "category1"}, {:name => "category2"}]
  end

  def given_a_store_with_sub_categories
    given_a_store_with [{ :name => "Root category",
                          :categories => [{:name => "sub_category1"},
                                          {:name => "sub_category2"}]}]
  end

  def given_a_store_with_items(items_attributes = [{ :name => "Item1", :price => 3.1}, { :name => "Item2", :price => 34.5}])
    given_a_store_with [{ :name => "Root category",
                          :categories => [{ :name => "sub_category",
                                            :items => items_attributes}]}]
  end

  def given_a_store_with_one_item
    given_a_store_with_items([{ :name => "Item1", :price => 2.5}])
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

      @store.should_receive(:starting_import).once

      import

      @recorded_calls.first.should == :starting_import
    end

    it "should call stop_import after registering items" do
      given_a_store_with_items

      @store.should_receive(:finishing_import).once

      import

      @recorded_calls.last.should == :finishing_import
    end

    it "should register item categories for root categories" do
      given_a_store_with_root_categories

      @root_categories.each do |category|
        @store.should_receive(:register_item_category).with(category.attributes.merge(:parent => nil))
      end

      import
    end

    it "should register item sub categories" do
      given_a_store_with_sub_categories

      @sub_categories.each do |sub_category|
        @store.should_receive(:register_item_category).with(sub_category.attributes.merge(:parent => @root_category.attributes.merge(:parent => nil)))
      end

      import
    end

    it "should register items" do
      given_a_store_with_items

      @items.each do |item|
        @store.should_receive(:register_item).with(item.attributes.merge(:item_categories => [@sub_category.attributes.merge(:parent => @root_category.attributes.merge(:parent => nil))]))
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
        @store.should_receive(:register_visited_url).with(walker.uri.to_s)
      end

      import
    end

    it "should register visited url AFTER the item was registered" do
      given_a_store_with_one_item

      @store.mock(:register_visited_url) do |uri|
        @store.should have_received(:register_item).with(@item.attributes)
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
      @store.should_receive(:starting_import)

      import
    end

    it "should not start a new import if the last one did not finish" do
      @store.stub(:last_import_finished?).and_return(false)
      @store.should_not_receive(:starting_import)

      import
    end

    it "should ask if urls were already visited with string uris" do
      uris = [@store_api.uri, @root_categories.first.uri, @sub_categories.first.uri, @items.first.uri]

      @store.should_receive(:already_visited_url?).with(instance_of(String)).exactly(uris.size).and_return(false)

      import
    end

    it "should not register item categories if urls were visited" do
      @store.stub(:already_visited_url?).and_return(true)

      @store.should_not_receive(:register_item_category)
      @store.should_not_receive(:register_item)

      import
    end

    it "should not register items if urls were visited" do
      @store.stub(:already_visited_url?).with(@item.uri.to_s).and_return(true)

      @store.should_receive(:register_item_category).twice
      @store.should_not_receive(:register_item)

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

    it "should continue on unimportable store pages" do
      new_page = Mechanize::Page.method(:new)
      Mechanize::Page.stub!(:new).and_return do |*args|
        result = new_page.call(*args)
        result.stub!(:search).and_return([])
        result
      end

      no_exception_should_climb_up_the_stack
    end

    it "should continue on badly formed store items" do
      @store.stub!(:register_item).and_raise(ActiveRecord::RecordInvalid.new(Item.new))

      no_exception_should_climb_up_the_stack
    end

    def exception_should_climb_up_the_stack(exception_class)
      @item.stub(:attributes).and_raise(exception_class.new("Test mock simulated error."))

      lambda { import }.should raise_error(exception_class)
    end

    def no_exception_should_climb_up_the_stack
      lambda { import }.should_not raise_error
    end

  end
end
