# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe Store do

  # setting static constants up
  before(:each) do
    @valid_attributes = { :url => AUCHAN_DIRECT_OFFLINE }

    @importer = mock(StoreImporter).as_null_object
    StoreImporter.stub(:new).and_return(@importer)
  end

  it "should create a new instance given valid attributes" do
    Store.create!(@valid_attributes)
  end

  it "should ask its importer to import" do
    @importer.should_receive(:import).with(AUCHAN_DIRECT_OFFLINE, anything())
    Store.new(@valid_attributes).import
  end

  it "should forward import options to the importer" do
    options = {:special => "sauce"}
    StoreImporter.should_receive(:new).with(options).and_return(@importer)
    Store.new(@valid_attributes).import(options)
  end

  it "should use its url host as name" do
    Store.new(:url => "http://www.hard-discount-store.eco/index").name.should == "www.hard-discount-store.eco"
  end

end
