# Copyright (C) 2012 by Philippe Bourgau

require "spec_helper"

describe StoreItemsDigger do

  before :each do
    @digger = StoreItemsDigger.new(@selector = "a.items", @factory = stub("Sub walker factory"))
    @page = stub(StoreWalkerPage)
    @page.stub(:search_links).with(@selector).and_return(@links = [stub("Link"),stub("Link")])
  end

  it "creates sub walkers for each link it finds" do
    @links.each do |link|
      @factory.should_receive(:new).with(link, anything, anything)
    end

    @digger.sub_walkers(@page, nil)
  end

  it "for debugging purpose, provides father walker and link index to sub walkers" do
    father = stub("Father walker")

    @links.each_with_index do |link, index|
      @factory.should_receive(:new).with(link, father, index)
    end

    @digger.sub_walkers(@page, father)
  end

end
