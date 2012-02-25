# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

describe ItemCategory do

  it "should have items" do
    category = ItemCategory.new(:name => "Boeuf")
    category.items.should_not be_nil
  end

  it "should be the ItemCategory from the db with name ROOT_NAME" do
    root = stub_model(ItemCategory, :name => ItemCategory::ROOT_NAME)
    ItemCategory.should_receive(:find_by_name).with(ItemCategory::ROOT_NAME).and_return(root)

    ItemCategory.root.should == root
  end

  it "should be the root if its name is ROOT_NAME" do
    ItemCategory.new(:name => ItemCategory::ROOT_NAME).should be_root
  end
  it "should not be the root if its name is not ROOT_NAME" do
    ItemCategory.new(:name => "another name").should_not be_root
  end

end
