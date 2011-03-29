# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe Store do

  # setting static constants up
  before(:each) do
    @valid_attributes = { :url => AUCHAN_DIRECT_OFFLINE }

    @scrapper = mock(StoreScrapper).as_null_object
    StoreScrapper.stub(:new).and_return(@scrapper)
  end

  it "should create a new instance given valid attributes" do
    Store.create!(@valid_attributes)
  end

  it "should ask its scrapper to import" do
    @scrapper.should_receive(:import).with(AUCHAN_DIRECT_OFFLINE, anything())
    Store.new(@valid_attributes).import
  end

  it "should forward import options to the scrapper" do
    options = {:special => "sauce"}
    StoreScrapper.should_receive(:new).with(options).and_return(@scrapper)
    Store.new(@valid_attributes).import(options)
  end

  it "should use its url host as name" do
    Store.new(:url => "http://www.hard-discount-store.eco/index").name.should == "www.hard-discount-store.eco"
  end

end
