# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe StoreItemsAPI do

  before :each do
    StoreItemsAPI.register_builder(my_store = "www.my-store.com", builder = stub(StoreItemsAPIBuilder.class))
    @url = "http://#{my_store}"
    StoreWalkerPage.stub(:open).with(@url).and_return(walker = stub(StoreWalkerPage))
    builder.stub(:new).with(walker).and_return(@store_api = stub(StoreItemsAPIBuilder))
  end

  it "select the good store items api builder to browse a store" do
    StoreItemsAPI.browse(@url).should == @store_api
  end

  it "fails when it does not know how to browse a store" do
    lambda { StoreItemsAPI.browse("http://unknown.store.com") }.should raise_error(NotImplementedError)
  end

end
