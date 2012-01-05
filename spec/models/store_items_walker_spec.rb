# Copyright (C) 2012 by Philippe Bourgau

require "spec_helper"

describe StoreItemsWalker do

  before :each do
    @page = stub("Page", :uri => "http://www.maxi-discount.com")
    getter = stub("Getter", :get => @page)
    @walker = StoreItemsWalker.new(getter)
  end

  context "by default" do
    it "has no items" do
      @walker.items.should be_empty
    end
    it "has no sub categories" do
      @walker.categories.should be_empty
    end
    it "has no attributes" do
      @walker.attributes.should be_empty
    end
  end

  it "has the uri of its page" do
    @walker.uri.should == @page.uri
  end

  before :each do
    @sub_walkers = [stub("Sub walker")]
    @digger = stub(StoreItemsDigger)
    @digger.stub(:sub_walkers).with(@page, @walker).and_return(@sub_walkers)
  end

  it "uses its items digger to collect its items" do
    @walker.items_digger = @digger

    @walker.items.should == @sub_walkers
  end
  it "uses its categories digger to collect its sub categories" do
    @walker.categories_digger = @digger

    @walker.categories.should == @sub_walkers
  end
  it "uses its scrap attributes block to collect its attributes" do
    attributes = { :name => "Candy" }
    @walker.scrap_attributes_block = lambda { |page| attributes }

    @walker.attributes.should == attributes
  end

end
