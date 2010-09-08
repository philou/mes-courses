# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'

describe "item/index.html.erb" do

  before(:each) do
    @items = ["Tomates", "Pommes de terre"].map {|name| stub_model(Item, :name => name) }
    assigns[:items] = @items
    render
  end

  it "displays the name of each item" do
    @items.each {|item| response.should contain(item.name) }
  end

  it "displays a link to add items to the cart" do
    @items.each {|item| response.should have_selector("a", :href => default_path(:controller => 'cart',
                                                                                 :action => 'add_item_to_cart',
                                                                                 :id => item.id)) }
  end

end

