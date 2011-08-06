# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe ApplicationHelper do
  include ApplicationHelper

  it "should create a default item category path for the nil category" do
    root_category_path = url_for(:controller => "item_categories")

    any_item_category_path.should == root_category_path
    any_item_category_path(nil).should == root_category_path
    any_item_category_path(stub(ItemCategory, :id => nil)).should == root_category_path
  end

  it "should create real item category path for the valid categories" do
    category = stub_model(ItemCategory, :id => 123)

    any_item_category_path(category).should == item_category_path(category)
  end

  it "should forward extra query params to item_category_path" do
    category = stub_model(ItemCategory, :id => 123)
    query = [category, { :search => { :keyword => "Bio"} } ]

    actual = any_item_category_path(*query)
    actual.should == item_category_path(*query)

    # rails inside's self learning ...
    actual.should_not == item_category_path(category)
  end

end
