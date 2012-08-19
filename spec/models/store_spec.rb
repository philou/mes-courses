# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe Store do

  # setting static constants up
  before(:each) do
    @valid_attributes = { :url => AUCHAN_DIRECT_OFFLINE, :expected_items => 10, :sponsored_url => AUCHAN_DIRECT_OFFLINE }

    @importer = mock(StoreImporter).as_null_object
    StoreImporter.stub(:new).and_return(@importer)

    Store.stub(:maximum).with(:expected_items).and_return(0)
  end

  it "should create a new instance given valid attributes" do
    Store.create!(@valid_attributes)
  end

  it "should ask its importer to import" do
    store = Store.new(@valid_attributes)

    browser = stub("Store Items API")
    StoreItemsAPI.stub(:browse).and_return(browser)

    robust_browser = stub(MesCourses::Utils::Retrier)
    MesCourses::Utils::Retrier.stub(:new).with(browser, anything).and_return(robust_browser)

    incremental_store = stub("Incremental store")
    IncrementalStore.stub(:new).with(store).and_return(incremental_store)

    @importer.should_receive(:import).with(robust_browser, incremental_store)

    store.import
  end

  it "should use its url host as name" do
    Store.new(:url => "http://www.hard-discount-store.eco/index").name.should == "www.hard-discount-store.eco"
  end

  it "should know the logout url of the cart api" do
    url = "http://www.megastore.com"
    MesCourses::Stores::Carts::Base.stub(:for_url).and_return(store_cart = stub(MesCourses::Stores::Carts::Base))
    store_cart.stub(:logout_url).and_return(url+"/logout")

    store = Store.new(:url => url)

    store.logout_url.should == store_cart.logout_url
  end

  context "importing all stores" do

    before :each do
      @stores = Array.new(2) { stub_model(Store) }
      @stores.each { |store| store.stub(:import) }
      Store.stub(:all).and_return(@stores)
    end

    it "should import all stores" do
      @stores.each { |store| store.should_receive(:import) }

      Store.import
    end

    it "update the stats first" do
      ModelStat.should_receive(:update!).ordered
      @stores.each { |store| store.should_receive(:import).ordered }

      Store.import
    end

    it "should deliver an import report email with time spent" do
      start_time = Time.local(2011, 10, 29, 16, 30, 24)
      end_time = Time.local(2011, 10, 29, 17, 48, 12)
      MesCourses::Utils::Timing.stub(:now).and_return(start_time, end_time)

      ImportReporter.should_receive(:delta).with(end_time - start_time, anything).and_return(email = stub("Email"))
      email.should_receive(:deliver)

      Store.import
    end

    it "should deliver an import report email" do
      expected_items = 3000
      Store.stub(:maximum).with(:expected_items).and_return(expected_items)

      ImportReporter.should_receive(:delta).with(anything, expected_items).and_return(email = stub("Email"))
      email.should_receive(:deliver)

      Store.import
    end

  end

  it "global import with an url should only import the specified store" do
    url = "http://www.discountagogo.com"

    store = stub_model(Store)
    Store.stub(:find_or_create_by_url).with(url).and_return(store)

    store.should_receive(:import)

    Store.import(url)
  end

end
