# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe "/item_type/show.html.erb" do

  before(:each) do
    item_sub_types = ["Pommes de terre", "Tomates", "Pommes"].map {|sub_type| stub_model(ItemSubType, :name => sub_type)}
    @item_type = stub_model(ItemType, :name => "Fruits & Légumes", :item_sub_types => item_sub_types)
    assigns[:item_type] = @item_type
    render
  end

  it "displays the name of the item type" do
    response.should contain(@item_type.name)
  end

  it "displays the names of its item sub types" do
    @item_type.item_sub_types.each do |item_sub_type|
      response.should contain(item_sub_type.name)
    end
  end

  it "has a link to each of its item sub types" do
    @item_type.item_sub_types.each do |item_sub_type|
      response.should have_selector("a", :href => item_sub_type_path(item_sub_type))
    end
  end

end
