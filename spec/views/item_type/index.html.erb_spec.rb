# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe "/item_type/index.html.erb" do

  before(:each) do
    @item_types = ["Produits laitiers", "Fruits & Légumes"].map {|name| stub_model(ItemType, :name => name) }
    assigns[:item_types] = @item_types
    render
  end

  it "displays the name of each item type" do
    @item_types.each {|item_type| response.should contain(item_type.name) }
  end

  it "displays a link to each item type" do
    @item_types.each {|item_type| response.should have_selector("a", :href => item_type_path(item_type)) }
  end

end
