# -*- encoding: utf-8 -*-
# Copyright (C) 2010, 2011, 2012 by Philippe Bourgau

require 'spec_helper'

describe Item do

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
      @tomates = Item.new(:name => "Tomates")
      @tomates_cerises = Item.new(:name => "Tomates cerises")
      @concombres = Item.new(:name => "Concombres")

      @legumes = ItemCategory.new(:name => "Légumes", :id => 11, :items => [@tomates, @tomates_cerises, @concombres])

      @cerises = Item.new(:name => "Cerises")
      @abricots = Item.new(:name => "Abricots")

      @fruits = ItemCategory.new(:name => "Fruits", :id => 22, :items => [@cerises, @abricots])

      @marche = ItemCategory.new(:name => "Marché", :id => 33, :children => [@legumes, @fruits])
      @marche.children.each { |child| child.parent = @marche}

      @tomates_confites = Item.new(:name => "Tomates confites")
      @salade_cesar = Item.new(:name => "Salade césar", :summary => "Salade préparée, antipastis et poulet pané")

      @italien = ItemCategory.new(:name => "Italien", :id => 44, :items => [@tomates_confites, @salade_cesar])

      @traiteur = ItemCategory.new(:name => "Traiteur", :id => 55, :children => [@italien])
      @traiteur.children.each { |child| child.parent = @traiteur}

      @root_item_category = ItemCategory.new(:name => ItemCategory::ROOT_NAME, :id => 66, :children => [@marche, @traiteur])
      @root_item_category.children.each { |child| child.parent = @root_item_category}
    end

    it "should directly search items when it has no children" do
      keyword = "tomates"
      expected = [@tomates, @tomates_cerises]

      Item.should_receive(:where).
        with(/item_category_id = :category_id/, hash_including(:category_id => @legumes.id)).
        and_return(join_mock(expected))

      Item.search_by_string_and_category(keyword, @legumes).should == expected
    end

    def join_mock(result)
      mock = stub("Where clause")
      mock.stub(:joins).with("INNER JOIN item_categories_items ON (items.id = item_categories_items.item_id)").and_return(result)
      mock
    end

    it "should search in sub categories when it has no parent" do
      keyword = "cerises"
      expected = [@tomates_cerises, @cerises]

      Item.should_receive(:where).
        with(/item_category_id in \(:category_ids\)/, hash_including(:category_ids => [@legumes.id,@fruits.id])).
        and_return(join_mock(expected))

      Item.search_by_string_and_category(keyword, @marche).should == expected
    end

    it "should search all items when root category is specified" do
      keyword = "tomates"
      expected = [@tomates, @tomates_cerises, @tomates_confites]

      Item.should_receive(:where).and_return(join_mock(expected))

      Item.search_by_string_and_category(keyword, @root_item_category).should == expected
    end

    it "should search in tokens column" do
      search_string = "poulet"

      Item.should_receive(:where).
        with(/items.tokens like :token0/, hash_including(:token0 => "%#{search_string}%")).
        exactly(3).times.
        and_return(join_mock([@salade_cesar]))

      Item.search_by_string_and_category(search_string, @root_item_category)
      Item.search_by_string_and_category(search_string, @traiteur)
      Item.search_by_string_and_category(search_string, @italien)
    end

    it "should search every tokens in the search string" do
      search_string = "any search string"
      tokens = %w(poulet salade)
      Tokenizer.stub(:run).and_return(tokens)

      Item.should_receive(:where).
        with(/items.tokens like :token0 and items.tokens like :token1/, hash_including(:token0 => "%#{tokens[0]}%", :token1 => "%#{tokens[1]}%")).
        exactly(3).times.
        and_return(join_mock([@salade_cesar]))

      Item.search_by_string_and_category(search_string, @root_item_category)
      Item.search_by_string_and_category(search_string, @traiteur)
      Item.search_by_string_and_category(search_string, @italien)
    end
  end
end
