# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require 'models/store_items_api_shared_examples'
require File.join(Rails.root, 'app', 'models', 'real_dummy_store_items_api')
require_relative "real_dummy_store_generator"

describe "RealDummyStoreItemsAPI", slow: true do
  include StoreItemsAPISpecMacros

  it_should_behave_like_any_store_items_api

  before :each do
    RealDummyStore.wipe_out
    RealDummyStore.open(store_name = "www.spec-store.com").generate(3).categories.and(3).categories.and(3).items
    @store = StoreItemsAPI.browse(RealDummyStore.uri(store_name))
  end

end
