# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'api_shared_examples'

module MesCourses::Stores::Items

  describe DummyApi do
    include ApiSpecMacros

    it_should_behave_like_any_store_items_api

    before :each do
      @store = DummyApi.new_default_store
    end

    it "should have the total item count" do
      @store.total_items_count.should == 3*3*3
    end

  end
end
