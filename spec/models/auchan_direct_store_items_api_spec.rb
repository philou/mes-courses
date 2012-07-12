# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require File.expand_path(File.join(File.dirname(__FILE__),'auchan_direct_store_items_api_shared_examples'))
require 'offline_test_helper'

include OfflineTestHelper

when_online "AuchanDirectStoreItemsAPI remote spec" do

  describe "AuchanDirectStoreItemsAPI", slow: true, remote: true do
    include AuchanDirectStoreItemsAPISpecMacros

    before :all do
      @store = StoreItemsAPI.browse("http://www.auchandirect.fr")
    end

    it_should_behave_like_any_auchan_direct_store_items_api

  end
end
