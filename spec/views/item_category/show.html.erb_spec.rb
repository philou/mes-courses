# Copyright (C) 2011 by Philippe Bourgau

require 'spec_helper'

describe "/item_category/show.html.erb" do
  include ApplicationHelper

  before(:each) do
    assigns[:categories] = @categories = ["Produits laitiers", "Fruits & Légumes"].map {|name| stub_model(ItemCategory, :name => name) }
    assigns[:search_url] = @search_url = "/item_category/search_it"
    assigns[:title] = "Tous les produits"
    assigns[:items] = []
  end

  it "has a search form" do
    render

    response.should have_xpath('//form[@id="search"]//input[@name="search[keyword]"][@type="text"]')
    response.should have_xpath('//form[@id="search"]//input[@type="submit"]')
    response.should have_xpath('//form[@id="search"][@method="get"][@action="'+@search_url+'"]')
  end

  describe "a category with children" do

    it "displays the names of its children" do
      render

      @categories.each do |category|
        response.should contain(category.name)
      end
    end

    it "has a link to each of its children" do
      render

      @categories.each do |category|
        response.should have_selector("a", :href => item_category_path(category))
      end
    end

  end

  describe "a category with items" do
    before(:each) do
      assigns[:categories] = []
      assigns[:items] = @items = ["Bavette", "Entrecôte"].map {|item| stub_model(Item,
                                                              :name => item,
                                                              :price => item.length/100.0,
                                                              :summary => "#{item} extra",
                                                              :image => "http://www.photofabric.com/#{item}")}
    end

    [:name, :price, :summary].each do |attribute|
      it "displays the #{attribute} of its items" do
        render

        @items.each do |item|
          response.should contain(item.send(attribute).to_s)
        end
      end
    end

    it "displays a link to add each of its items to the cart" do
      render

      @items.each do |item|
        response.should have_selector("a", :href => default_path(:controller => 'cart',
                                                                 :action => 'add_item',
                                                                 :id => item.id))
      end
    end

    it "displays the image of its items" do
      render

      @items.each do |item|
        response.should have_selector("img", :src => item.image)
      end
    end

    it "displays the number of items" do
      render

      response.should contain("#{@items.count} ingrédient(s)")
    end

  end
end
