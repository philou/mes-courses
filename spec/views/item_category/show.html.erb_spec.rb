# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe "/item_category/show.html.erb" do
  include ApplicationHelper

  before(:each) do
    sub_categories = ["Produits laitiers", "Fruits & Légumes"].map {|name| stub_model(ItemCategory, :name => name) }
    @item_category = ItemCategory.new(:name => "Tous les produits", :children => sub_categories)
    assigns[:item_category] = @item_category
  end

  it "has a search form" do
    render

    response.should have_xpath('//form[@id="search"]//input[@name="search[keywords]"][@type="text"]')
    response.should have_xpath('//form[@id="search"]//input[@type="submit"]')
    response.should have_xpath('//form[@id="search"][@method="post"][@action="'+any_item_category_path(@item_category)+'"]')
  end

  describe "a category with children" do

    it "displays the names of its children" do
      render

      @item_category.children.each do |category|
        response.should contain(category.name)
      end
    end

    it "has a link to each of its children" do
      render

      @item_category.children.each do |category|
        response.should have_selector("a", :href => item_category_path(category))
      end
    end

  end

  describe "a category with items" do
    before(:each) do
      items = ["Bavette", "Entrecôte"].map {|item| stub_model(Item,
                                                              :name => item,
                                                              :price => item.length/100.0,
                                                              :summary => "#{item} extra",
                                                              :image => "http://www.photofabric.com/#{item}")}
      @item_category = stub_model(ItemCategory, :name => "Viande de boeuf", :items => items)
      assigns[:item_category] = @item_category
    end

    [:name, :price, :summary].each do |attribute|
      it "displays the #{attribute} of its items" do
        render

        @item_category.items.each do |item|
          response.should contain(item.send(attribute).to_s)
        end
      end
    end

    it "displays a link to add each of its items to the cart" do
      render

      @item_category.items.each do |item|
        response.should have_selector("a", :href => default_path(:controller => 'cart',
                                                                 :action => 'add_item',
                                                                 :id => item.id))
      end
    end

    it "displays the image of its items" do
      render

      @item_category.items.each do |item|
        response.should have_selector("img", :src => item.image)
      end
    end
  end
end
