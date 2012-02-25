# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'


# @integration
describe StoreWalkerPage do

  before :each do
    @uri = URI.parse("file://" + File.expand_path(File.join(File.dirname(__FILE__), 'store_walker_page_spec_fixture.html')))
    @page_getter = StoreWalkerPage.open(@uri)
  end

  context "before actually getting the page" do
    it "nothing should throw if the uri is invalid" do
      lambda { StoreWalkerPage.open("http://impossible.file.name") }.should_not raise_error
    end

    it "knows the uri of the page" do
      @page_getter.uri.should == @uri
    end

    it "has text of the uri" do
      @page_getter.text.should == @uri.to_s
    end
  end

  context "after actually getting the page" do
    before :each do
      @page = @page_getter.get
    end

    it "delegates uri to the mechanize page" do
      @page.uri.should == @uri
    end

    it "finds an element by css" do
      element = @page.get_one("#unique")

      element.should_not be_nil
      element.attribute("id").value.should == "unique"
    end

    it "finds only the first element by css" do
      @page.get_one(".number").text.should == "0"
    end

    it "throws if it cannot find the element by css" do
      lambda { @page.get_one("#invalid_id") }.should raise_error(StoreWalkerPageError)
    end

    it "finds relative links sorted by uri" do
      links = @page.search_links("a.letter")

      uris = links.map { |link| link.uri.to_s }
      uris.should == ["a.html", "b.html"]
    end

    it "does not find links to other domains" do
      @page.search_links("#outbound").should be_empty
    end

    it "ignores duplicate links" do
      @page.search_links("a.twin").should have(1).link
    end

    it "links to other instances of StoreWalkerPage" do
      @page.search_links("#myself").map { |link| link.get }.should all(be_instance_of(StoreWalkerPage))
    end

    it "knows the text of the links" do
      @page.search_links("#myself").each do |link|
        link.text.should == "myself"
      end
    end
  end
end
