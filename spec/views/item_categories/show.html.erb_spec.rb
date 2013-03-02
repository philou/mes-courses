# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'

describe "item_categories/show" do
  include ApplicationHelper
  include KnowsPageParts

  before(:each) do
    assign :show_sub_category_url_options, @show_sub_category_url_options = {:controller => 'item_categories', :action => 'index'}
    assign :add_item_label, @add_item_label = "Acheter"
    assign :add_item_url_options, @add_item_url_options = {:controller => 'cart_lines', :action => 'create'}
    assign :add_item_html_options, @add_item_html_options = {:method => :post}
    assign :categories, @categories = ["Produits laitiers", "Fruits & Légumes"].map {|name| stub_model(ItemCategory, :name => name) }
    assign :search_url, @search_url = "/item_category/search_it"
    assign :title, "Tous les produits"
    assign :items, []
  end

  it "has a search form" do
    render

    rendered.should have_xpath('//form[@id="search"]//input[@name="search[search_string]"][@type="text"]')
    rendered.should have_xpath('//form[@id="search"]//input[@type="submit"]')
    rendered.should have_xpath("//form[@id='search'][@method='get'][@action='#{@search_url}']")
  end

  describe "a category with children" do

    it "displays the names of its children" do
      render

      @categories.each do |category|
        rendered.should contain(category.name)
      end
    end

    it "has a link to each of its children" do
      render

      @categories.each do |category|
        rendered.should have_selector("a", :href => url_for(@show_sub_category_url_options.merge(:id => category.id)))
      end
    end

  end

  describe "a category with items" do
    before(:each) do
      assign :categories, []
      assign :items, @items = ["Bavette", "Entrecôte"].map {|item| stub_model(Item,
                                                              :name => item,
                                                              :price => item.length/100.0,
                                                              :brand => "#{item} INC",
                                                              :image => "http://www.photofabric.com/#{item}")}
    end

    [:name, :price, :brand].each do |attribute|
      it "displays the #{attribute} of its items" do
        render

        @items.each do |item|
          rendered.should contain(item.send(attribute).to_s)
        end
      end
    end

    it "displays a button to buy each item" do
      render

      @items.each do |item|
        rendered.should have_button_to(@add_item_label, url_for(@add_item_url_options.merge(:id => item.id)), @add_item_html_options[:method])
      end
    end

    it "displays the image of its items" do
      render

      @items.each do |item|
        rendered.should have_selector("img", :src => https_url(item.image))
      end
    end

    it "displays the number of items" do
      render

      rendered.should contain("#{@items.count} ingrédients")
    end

    it "displays disabled items accordingly" do
      item = @items.first
      item.stub(:item_categories).and_return([ItemCategory.disabled])

      render

      rendered.should contain_a(disabled_item_with_name(item.name))
    end

  end
end
