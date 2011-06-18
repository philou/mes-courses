# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe ItemCategoryControllerDishNesting do
  controller_name :item_category

  before :each do
    @dish = stub_model(Dish, :name => "Salade")
    @nesting = ItemCategoryControllerDishNesting.new(@dish.id)
    Dish.stub!(:find_by_id).with(@dish.id).and_return(@dish)
  end

  it "should create path bars starting from dishes" do
    @nesting.root_path_bar.should == [PathBar.element("Recettes", dish_index_path), PathBar.element(@dish.name, dish_path(@dish))]
  end

  it "should use dish url for root url of item categories" do
    @nesting.item_category_index_path.should == dish_item_category_index_path(@dish.id)
  end

  it "should use dish urls for urls of item categories" do
    item_category = stub_model(ItemCategory)
    @nesting.item_category_path(item_category).should == dish_item_category_path(@dish.id, item_category)
  end

  it "should use a dish url to add items" do
    @nesting.add_item_url_options.should == {:controller => 'items', :action => 'create', :dish_id => @dish.id}
  end

  it "should use a dish url to link to sub item categories" do
    @nesting.show_sub_category_url_options.should == {:controller => 'item_category', :action => 'show', :dish_id => @dish.id}
  end
end
