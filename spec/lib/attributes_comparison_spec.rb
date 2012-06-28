# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2012 by Philippe Bourgau

require 'spec_helper'
require 'attributes_comparison'

describe "ActiveRecord attributes comparison" do

  before(:each) do
    @item_attributes = FactoryGirl.attributes_for :item
    @item = Item.new(@item_attributes)
    @item_category_attributes = FactoryGirl.attributes_for :item_category
    @item_category = ItemCategory.new(@item_category_attributes)
    @another_item_category = FactoryGirl.build :item_category
  end

  it "equals initial attributes" do
    @item.should be_equal_to_attributes(@item_attributes)
  end

  it "does not equal attributes with another price" do
    @item_attributes[:price] += 2.3
    @item.should_not be_equal_to_attributes(@item_attributes)
  end

  it "does not equal attributes with another summary" do
    @item_attributes[:summary] = @item_attributes[:summary] + " poids net 250g"
    @item.should_not be_equal_to_attributes(@item_attributes)
  end

  it "does not equal attributes with an extra value" do
    @item_attributes[:unknown] = "Super promo"
    @item.should_not be_equal_to_attributes(@item_attributes)
  end

  it "equals attributes with a belongs_to association" do
    @item_category_attributes[:parent] = @another_item_category
    @item_category.parent = @another_item_category
    @item_category.should be_equal_to_attributes(@item_category_attributes)
  end

  it "does not equal attributes with a different belongs_to association" do
    @item_category_attributes[:parent] = @another_item_category
    @item_category.should_not be_equal_to_attributes(@item_category_attributes)
  end

  it "equals attributes with a habtm association" do
    @item.item_categories.push(@item_category)
    @item_attributes[:item_categories] = [@item_category]
    @item.should be_equal_to_attributes(@item_attributes)
  end

  it "does not equal attributes with a different habtm association" do
    @item_attributes[:item_category] = [@item_category]
    @item.should_not be_equal_to_attributes(@item_attributes)
  end

end
