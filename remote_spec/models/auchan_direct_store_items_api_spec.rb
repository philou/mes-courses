# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require File.expand_path(File.join(File.dirname(__FILE__),'auchan_direct_store_items_api_shared_examples'))
require 'lib/offline_test_helper'

include OfflineTestHelper

when_online "AuchanDirectStoreItemsAPI remote spec" do

  describe "AuchanDirectStoreItemsAPI" do
    before :all do @store = auchan_direct_store_items_api("http://www.auchandirect.fr") end
    it_should_behave_like "Any AuchanDirectStoreItemsAPI"
  end

end
