# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/store_items_api_shared_examples'

describe "OfflineAuchanDirectStoreItemsAPI" do
  before :all do @store = AuchanDirectStoreItemsAPI.new(AUCHAN_DIRECT_OFFLINE) end
  it_should_behave_like "Any StoreItemsAPI"
end
