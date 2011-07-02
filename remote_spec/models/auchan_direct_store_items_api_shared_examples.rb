# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'
require 'models/store_items_api_shared_examples'

shared_examples_for "Any AuchanDirectStoreItemsAPI" do
  it_should_behave_like "Any StoreItemsAPI"

  it "should not truncate long names of items" do
    sample_items_attributes.find_all {|item| 20 <= item[:name].length }.should_not be_empty
  end

end
