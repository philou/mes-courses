# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'models/scrapper_spec_helper'

describe Scrapper do
  include ScrapperSpecHelper

  # we are importing only once because it takes a lot of time. All the tests should be side effect free.
  before(:all) do
    @items = []
    @scrapper = Scrapper.new
    when_importing_from(@scrapper, :skip_links_like => /^http:\/\//, :squeeze_loops_to => 2)
    @scrapper.import(AUCHAN_DIRECT_OFFLINE, self)
  end

  # when the scrapper founds an item, keep it safe
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
    items.should have_at_least(1).item
  end

  it "should organize items by type and subtype" do
    pending

    @items.each do |item|
      item.sub_type.should_not be_nil
      item.sub_type.type.should_not be_nil
    end
  end

end
