# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require File.expand_path(File.join(File.dirname(__FILE__),'auchan_direct_store_items_api_shared_examples'))

describe "OfflineAuchanDirectStoreItemsAPI" do
  before :all do @store = auchan_direct_store_items_api(AUCHAN_DIRECT_OFFLINE) end
  it_should_behave_like "Any AuchanDirectStoreItemsAPI"
end
