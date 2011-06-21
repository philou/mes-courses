# Copyright (C) 2010, 2011 by Philippe Bourgau

require 'spec_helper'

# argument matcher for :conditions => parameters in active record find method
class WhereConditionsContainingMatcher
  def initialize(sql, params)
    @sql = sql
    @params = params
  end
  def ==(actual)
    actual_sql = actual[:conditions][0]
    return false unless actual_sql.include?(@sql)

    actual_params = actual[:conditions][1]
    @params.each do |k,v|
      return false unless actual_params[k] == v
    end
    true
  end
  def description
    "Something ~deep including~ #{{:conditions => [@sql, @params]}.inspect}"
  end
end

def where_conditions_containing(sql, params = {})
  WhereConditionsContainingMatcher.new(sql, params)
end
def where_conditions()
  WhereConditionsContainingMatcher.new("", {})
end

describe Item do

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

      Item.should_receive(:find).
        with(:all, where_conditions_containing("item_category_id = :category_id", :category_id => @legumes.id)).
        and_return(expected)

      Item.search_by_keyword_and_category(keyword, @legumes).should == expected
    end

    it "should search in sub categories when it has no parent" do
      keyword = "cerises"
      expected = [@tomates_cerises, @cerises]

      Item.should_receive(:find).
        with(:all, where_conditions_containing("item_category_id in (:category_ids)", :category_ids => [@legumes.id,@fruits.id])).
        and_return(expected)

      Item.search_by_keyword_and_category(keyword, @marche).should == expected
    end

    it "should search all items when root category is specified" do
      keyword = "tomates"
      expected = [@tomates, @tomates_cerises, @tomates_confites]

      Item.should_receive(:find).
        with(:all, where_conditions).
        and_return(expected)

      Item.search_by_keyword_and_category(keyword, @root_item_category).should == expected
    end

    it "should search in both item names and summaries too" do
      keyword = "poulet"

      Item.should_receive(:find).
        with(:all, where_conditions_containing("(lower(name) like :keyword or lower(summary) like :keyword)", :keyword => "%#{keyword.downcase}%")).
        exactly(3).times.
        and_return([@salade_cesar])

      Item.search_by_keyword_and_category(keyword, @root_item_category)
      Item.search_by_keyword_and_category(keyword, @traiteur)
      Item.search_by_keyword_and_category(keyword, @italien)
    end
  end
end
