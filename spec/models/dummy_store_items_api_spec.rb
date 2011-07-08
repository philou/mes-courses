# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/store_items_api_shared_examples'

describe DummyStoreItemsAPI do
  before :each do
    @store = DummyStoreItemsAPI.new_default_store
  end

  it_should_behave_like "Any StoreItemsAPI"

end
