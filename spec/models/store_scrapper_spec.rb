# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'models/store_scrapper_spec_helper'
require 'mostly_matcher'
require 'all_matcher'
require 'have_unique_matcher'

describe StoreScrapper do
  include StoreScrapperSpecHelper

  # we are importing only once because it takes a lot of time. All the tests should be side effect free.
  before(:all) do
    @scrapper = StoreScrapper.new
    when_importing_from(@scrapper, :skip_links_like => /^http:\/\//, :squeeze_loops_to => 2)

    store = stub("Store")
    record_calls(store, :starting_import, :finishing_import, :register_item_type, :register_item_sub_type, :register_item)

    @scrapper.import(AUCHAN_DIRECT_OFFLINE, store)
  end

  def record_calls(stub_object, *selectors)
    @recorded_calls = []
    selectors.each do |selector|
      record_calls_to(stub_object, selector)
    end
  end
  def record_calls_to(stub_object, selector)
    collector = []
    self.instance_variable_set("@#{selector}s".intern, collector)

    # warning because start_import and stop_import does not have any arguments ...
    stub_object.stub(selector) do |*args|
      recorded_args = arguments(args)

      @recorded_calls.push({:selector => selector, :arguments => recorded_args})
      collector.push(recorded_args)
      recorded_args
    end
  end
  def arguments(args)
    if (args.count == 1)
      args.first
    else
      args
    end
  end
  def calls_with_selector(selector)
    @recorded_calls.find_all do |call|
      call[:selector] == selector
    end
  end

  it "should call start_import before registering items" do
    @recorded_calls.first[:selector].should == :starting_import
    calls_with_selector(:starting_import).should have(1).entry
  end
  it "should call stop_import before registering items" do
    @recorded_calls.last[:selector].should == :finishing_import
    calls_with_selector(:finishing_import).should have(1).entry
  end

  it "should create many items" do
    @register_items.should have_at_least(3).records
  end

  it "should create item types" do
    @register_item_types.should_not be_empty
  end

  it "should create different items types" do
    @register_item_types.should mostly have_unique(:name)
  end

  it "should create item sub types" do
    @register_item_sub_types.should_not be_empty
  end

  it "should create different items sub types" do
    @register_item_sub_types.should mostly have_unique(:name)
  end

  it "should organize items by type and subtype" do
    @register_items.each do |item|
      item[:item_sub_type].should_not be_nil
      item[:item_sub_type][:item_type].should_not be_nil
    end
  end

  it "should create different items" do
    @register_items.should mostly have_unique(:name)
  end

  it "should create full named items" do
    @register_items.find_all {|item| 20 <= item[:name].length }.should_not be_empty
  end

  it "should create items with a price" do
    @register_items.should all have_key(:price)
  end

  it "should create most items with an image" do
    @register_items.should mostly have_key(:image)
  end

  it "should create most items with a summary" do
    @register_items.should mostly have_key(:summary)
  end

end
