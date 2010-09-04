# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'models/scrapper_spec_helper'

describe Scrapper do
  include ScrapperSpecHelper

  # we are importing only once because it takes a lot of time. All the tests should be side effect free.
  before(:all) do
    @item_types = []
    @item_sub_types = []
    @items = []
    @scrapper = Scrapper.new
    when_importing_from(@scrapper, :skip_links_like => /^http:\/\//, :squeeze_loops_to => 2)
    @scrapper.import(AUCHAN_DIRECT_OFFLINE, self)
  end

  # when the scrapper founds something, keep it for later testing
  def found_item_type(params)
    result = ItemType.new(params)
    @item_types.push(result)
    result
  end
  def found_item_sub_type(params)
    result = ItemSubType.new(params)
    @item_sub_types.push(result)
    result
  end
  def found_item(params)
    @items.push(Item.new(params))
  end

  it "should create many items" do
    @items.should have_at_least(3).records
  end

  it "should create different items" do
    names = Set.new(@items.map {|item| item.name})
    names.should have_at_least(@items.length * 0.7).unique_values
  end

  it "should create full named items" do
    items = @items.find_all {|item| 20 <= item.name.length }
    items.should_not be_empty
  end

  it "should create item types" do
    @item_types.should_not be_empty
  end

  it "should create item sub types" do
    @item_sub_types.should_not be_empty
  end

  it "should organize items by type and subtype" do
    @items.each do |item|
      item.item_sub_type.should_not be_nil
      item.item_sub_type.item_type.should_not be_nil
    end
  end

end
