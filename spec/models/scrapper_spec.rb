# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'models/scrapper_spec_helper'
require 'mostly_matcher'
require 'all_matcher'
require 'have_unique_matcher'

describe Scrapper do
  include ScrapperSpecHelper

  # we are importing only once because it takes a lot of time. All the tests should be side effect free.
  before(:all) do
    @scrapper = Scrapper.new
    when_importing_from(@scrapper, :skip_links_like => /^http:\/\//, :squeeze_loops_to => 2)

    importer = stub("Importer")
    record_calls(importer, :found_item_type, :found_item_sub_type, :found_item)

    @scrapper.import(AUCHAN_DIRECT_OFFLINE, importer)
  end

  def record_calls(stub_object, *selectors)
    selectors.each do |message|
      collector = []
      self.instance_variable_set("@#{message}s".intern, collector)

      stub_object.stub(message) do |params|
        collector.push(params)
        params
      end
    end
  end

  it "should create many items" do
    @found_items.should have_at_least(3).records
  end

  it "should create item types" do
    @found_item_types.should_not be_empty
  end

  it "should create different items types" do
    @found_item_types.should mostly have_unique(:name)
  end

  it "should create item sub types" do
    @found_item_sub_types.should_not be_empty
  end

  it "should create different items sub types" do
    @found_item_sub_types.should mostly have_unique(:name)
  end

  it "should organize items by type and subtype" do
    @found_items.each do |item|
      item[:item_sub_type].should_not be_nil
      item[:item_sub_type][:item_type].should_not be_nil
    end
  end

  it "should create different items" do
    @found_items.should mostly have_unique(:name)
  end

  it "should create full named items" do
    @found_items.find_all {|item| 20 <= item[:name].length }.should_not be_empty
  end

  it "should create items with a price" do
    @found_items.should all have_key(:price)
  end

  it "should create most items with an image" do
    @found_items.should mostly have_key(:image)
  end

  it "should create most items with a summary" do
    @found_items.should mostly have_key(:summary)
  end
end
