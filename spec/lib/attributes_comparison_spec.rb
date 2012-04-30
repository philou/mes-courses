# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012 by Philippe Bourgau

require 'spec_helper'
require 'attributes_comparison'

describe "ActiveRecord attributes comparison" do

  before(:each) do
    @attributes = {:name => "Bavette de boeuf", :price => 5.4, :summary => "Viande française de qualité", :image => "http://ze_bavette.jpg" }
    @item = Item.new(@attributes)
    @item_category = ItemCategory.new(:name => "Boeuf")
  end

  it "should have attributes equal to initials" do
    @item.should be_equal_to_attributes(@attributes)
  end

  it "should have different attributes than initials with another price" do
    @attributes[:price] = 2.3
    @item.should_not be_equal_to_attributes(@attributes)
  end

  it "should have different attributes than initials with another summary" do
    @attributes[:summary] = "250g"
    @item.should_not be_equal_to_attributes(@attributes)
  end

  it "should have attributes equal to initials with an actual reference" do
    @item.item_category = @item_category
    @attributes[:item_category] = @item_category
    @item.should be_equal_to_attributes(@attributes)
  end

  it "should have attributes different than initials with an unknown attribute" do
    @attributes[:unknown] = "Super promo"
    @item.should_not be_equal_to_attributes(@attributes)
  end

end
