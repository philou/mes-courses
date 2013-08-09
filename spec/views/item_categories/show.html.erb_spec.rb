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

    assign :categories, @categories = FactoryGirl.create_list(:item_category, 2)
    assign :search_url, @search_url = "/item_category/search_it"
    assign :title, "Tous les produits"
    assign :items, []
  end

  it "has a search form" do
    render

    expect(rendered).to have_xpath('//form[@id="search"]//input[@name="search[search_string]"][@type="text"]')
    expect(rendered).to have_xpath('//form[@id="search"]//input[@type="submit"]')
    expect(rendered).to have_xpath("//form[@id='search'][@method='get'][@action='#{@search_url}']")
  end

  describe "a category with children" do

    it "displays the names of its children" do
      render

      @categories.each do |category|
        expect(rendered).to contain(category.name)
      end
    end

    it "has a link to each of its children" do
      render

      @categories.each do |category|
        expect(rendered).to have_selector("a", :href => url_for(@show_sub_category_url_options.merge(:id => category.id)))
      end
    end

  end

  describe "a category with items" do
    before(:each) do
      assign :categories, []
      assign :items, @items = FactoryGirl.create_list(:item, 2)
    end

    [:name, :price, :brand].each do |attribute|
      it "displays the #{attribute} of its items" do
        render

        @items.each do |item|
          expect(rendered).to contain(item.send(attribute).to_s)
        end
      end
    end

    it "displays a button to buy each item" do
      render

      @items.each do |item|
        expect(rendered).to have_button_to(@add_item_label, url_for(@add_item_url_options.merge(:id => item.id)), @add_item_html_options[:method])
      end
    end

    it "displays the image of its items" do
      render

      @items.each do |item|
        expect(rendered).to have_selector("img", :src => https_url(item.image))
      end
    end

    it "displays the number of items" do
      render

      expect(rendered).to contain("#{@items.count} ingrédients")
    end

    it "displays disabled items accordingly" do
      item = @items.first.disable

      render

      expect(rendered).to contain_a(disabled_item_with_name(item.name))
    end

  end
end
