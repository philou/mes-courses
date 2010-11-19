# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe "/item_category/index.html.erb" do

  before(:each) do
    @item_categories = ["Produits laitiers", "Fruits & Légumes"].map {|name| stub_model(ItemCategory, :name => name) }
    assigns[:item_categories] = @item_categories
    render
  end

  it "displays the name of each item category" do
    @item_categories.each do |category|
      response.should contain(category.name)
    end
  end

  it "displays a link to each item category" do
    @item_categories.each do |category|
      response.should have_selector("a", :href => item_category_path(category))
    end
  end

end
