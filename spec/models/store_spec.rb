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
    store = Store.new(@valid_attributes)

    browser = stub("Store Items API")
    StoreItemsAPI.stub(:browse).and_return(browser)

    robust_browser = stub(Retrier)
    Retrier.stub(:new).with(browser, anything).and_return(robust_browser)

    incremental_store = stub("Incremental store")
    IncrementalStore.stub(:new).with(store).and_return(incremental_store)

    @importer.should_receive(:import).with(robust_browser, incremental_store)

    store.import
  end

  it "should use its url host as name" do
    Store.new(:url => "http://www.hard-discount-store.eco/index").name.should == "www.hard-discount-store.eco"
  end

end
