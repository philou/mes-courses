# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe Store do

  # setting static constants up
  before(:all) do
    @valid_attributes = { :url => AUCHAN_DIRECT_OFFLINE }
  end

  it "should create a new instance given valid attributes" do
    Store.create!(@valid_attributes)
  end

  it "should ask its scrapper to import" do
    @store = Store.new(@valid_attributes)
    @store.scrapper = mock(Scrapper)
    @store.scrapper.should_receive(:import).with(AUCHAN_DIRECT_OFFLINE, anything())
    @store.import
  end

end
