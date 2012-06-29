# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require_relative 'singleton_builder_spec_macros'

describe Item do
  extend SingletonBuilderSpecMacros

  has_singleton(:lost, Constants::LOST_ITEM_NAME)

  it "has a lost item that is disabled" do
    Item.lost.item_categories.should include(ItemCategory.disabled), "item categories of lost item"
  end

  context "indexing" do

    before :each do
      @item = Item.new(:name => "Petits pois", :summary => "extra fins, produits en france")
    end

    it "should run tokenizer when indexing" do
      tokens = %w(token1 token2)
      Tokenizer.should_receive(:run).with("#{@item.name} #{@item.summary}").and_return(tokens)

      @item.index

      @item.tokens.should == tokens.join(" ")
    end

    it "should index when the name is set" do
      @item.name = "Haricots verts"

      should_be_indexed(@item)
    end

    it "should index when the summary is set" do
      @item.summary = "fins"

      should_be_indexed(@item)
    end

    it "should index at creation" do
      should_be_indexed(Item.new)
    end

    def should_be_indexed(item)
      item.tokens.should == Tokenizer.run("#{item.name} #{item.summary}").join(" ")
    end
  end

  context "when searching items by keyword" do

    before :each do
      @marche = FactoryGirl.build_stubbed(:item_category, name: "Marché", parent: ItemCategory.root)

      @legumes = FactoryGirl.build_stubbed(:item_category, name: "Légumes", parent: @marche)
      @fruits = FactoryGirl.build_stubbed(:item_category, name: "Fruits", parent: @marche)
      @marche.stub(:children).and_return([@legumes, @fruits])

      @expected = stub("Array of items")
    end

    it "should directly search items when it has no children" do
      Item.should_receive(:where).
        with(/item_category_id = :category_id/, hash_including(:category_id => @legumes.id)).
        and_return(join_mock)

      Item.search_by_string_and_category("tomates", @legumes).should == @expected
    end

    def join_mock()
      mock = stub("Where clause")
      mock.stub(:joins).with("INNER JOIN item_categories_items ON (items.id = item_categories_items.item_id)").and_return(@expected)
      mock
    end

    it "should search in sub categories when it has no parent" do
      Item.should_receive(:where).
        with(/item_category_id in \(:category_ids\)/, hash_including(:category_ids => [@legumes.id,@fruits.id])).
        and_return(join_mock)

      Item.search_by_string_and_category("cerise", @marche).should == @expected
    end

    it "should search all items when root category is specified" do
      Item.should_receive(:where).and_return(join_mock)

      Item.search_by_string_and_category("tomates", ItemCategory.root).should == @expected
    end

    it "should search in tokens column" do
      search_string = "poulet"

      Item.should_receive(:where).
        with(/items.tokens like :token0/, hash_including(:token0 => "%#{search_string}%")).
        exactly(3).times.
        and_return(join_mock)

      Item.search_by_string_and_category(search_string, ItemCategory.root)
      Item.search_by_string_and_category(search_string, @marche)
      Item.search_by_string_and_category(search_string, @legumes)
    end

    it "should search every tokens in the search string" do
      search_string = "any search string"
      tokens = %w(poulet salade)
      Tokenizer.stub(:run).and_return(tokens)

      Item.should_receive(:where).
        with(/items.tokens like :token0 and items.tokens like :token1/, hash_including(:token0 => "%#{tokens[0]}%", :token1 => "%#{tokens[1]}%")).
        exactly(3).times.
        and_return(join_mock)

      Item.search_by_string_and_category(search_string, ItemCategory.root)
      Item.search_by_string_and_category(search_string, @marche)
      Item.search_by_string_and_category(search_string, @legumes)
    end
  end
end
