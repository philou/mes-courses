# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

require 'spec_helper'
require 'lib/mes_courses/rails_utils/singleton_builder_spec_macros'

describe Item do
  extend MesCourses::RailsUtils::SingletonBuilderSpecMacros

  has_singleton(:lost, Constants::LOST_ITEM_NAME)

  it "has a lost item that is disabled" do
    Item.lost.item_categories.should include(ItemCategory.disabled), "item categories of lost item"
  end

  it "is not disabled by default" do
    Item.new.should_not be_disabled
  end

  it "is disabled if it has the disabled category" do
    Item.new.that_is_disabled.should be_disabled
  end

  it "has the specified image" do
    image = "dirty_potatoes.png"
    Item.new(image: image).image.should == image
  end
  it "has an unknown image if not specified" do
    Item.new.image.should == "/images/unknown.png"
  end
  it "has a disabled image if disabled" do
    Item.new.that_is_disabled.image.should == "/images/disabled.png"
    Item.new(image: 'muchy_peas.png').that_is_disabled.image.should == "/images/disabled.png"
  end

  it "presents a long name from its brand and name" do
    item = FactoryGirl.build(:item)
    item.long_name.should == "#{item.brand} #{item.name}"
  end

  context "indexing" do

    before :each do
      @item = Item.new(:name => "Petits pois", :brand => "Légumes frais")
    end

    it "should run tokenizer when indexing" do
      tokens = %w(token1 token2)
      MesCourses::Utils::Tokenizer.should_receive(:run).with(@item.long_name).and_return(tokens)

      @item.index

      @item.tokens.should == tokens.join(" ")
    end

    it "should index when the name is set" do
      @item.name = "Haricots verts"

      should_be_indexed(@item)
    end

    it "should index when the brand is set" do
      @item.brand = "JunkFood.inc"

      should_be_indexed(@item)
    end

    it "should index at creation" do
      should_be_indexed(Item.new)
    end

    def should_be_indexed(item)
      item.tokens.should == MesCourses::Utils::Tokenizer.run(item.long_name).join(" ")
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

    it "does not allow invalid search strings" do
      Item.search_string_is_valid?("something").should be_true
      Item.search_string_is_valid?("").should be_false
      Item.search_string_is_valid?("s").should be_false
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
      MesCourses::Utils::Tokenizer.stub(:run).and_return(tokens)

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
