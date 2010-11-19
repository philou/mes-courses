# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'all_matcher'
require 'lib/deep_clone'
require 'app/models/item_category'

describe "ActiveRecord deep clone" do

  before(:each) do
    @type = ItemCategory.new(:name => "Viandes")
    @another_type = ItemCategory.new(:name => "Riz, Pates")
    @category = ItemCategory.new(:name => "Boeuf", :parent => @type)
  end

  it "should clone a simple record" do
    type_clone = @type.deep_clone

    type_clone.should be_an(ItemCategory)
    type_clone.name.should == 'Viandes'
    type_clone.parent.should be_nil
  end

  it "should not hashify the record ids" do
    @type.id = 666
    type_clone = @type.deep_clone
    type_clone.id.should be_nil
  end

  it "should dehashify nil references" do
    ActiveRecord::Base.deep_clones([nil]).should be_empty
    lambda {
      ItemCategory.new(:name => "Unclassified").deep_clone
    }.should_not raise_error
  end

  it "should deep clone a list of records" do
    clones = ActiveRecord::Base.deep_clones([@type,@another_type])

    clones.should all be_an(ItemCategory)
    clones.map { |clone| clone.name }.sort.should == ['Riz, Pates', 'Viandes'].sort
  end

  it "should deep clone a record with references" do
    clones = ActiveRecord::Base.deep_clones([@category])

    category_clone = clones.find { |clone| !clone.parent.nil? }
    category_clone.should_not be_nil
    category_clone.name.should == "Boeuf"
    category_clone.parent.should_not be_nil
    category_clone.parent.name.should == "Viandes"
  end

  it "should add deep cloned references to the clones" do
    clones = ActiveRecord::Base.deep_clones([@category])

    type_clone = clones.find { |clone| clone.parent.nil? }
    type_clone.should_not be_nil
    type_clone.name.should == "Viandes"
  end

  it "should keep object identity when hashifying objects with references" do
    clones = ActiveRecord::Base.deep_clones([@category])
    category_should_reference_type(clones)
  end

  it "should not hashify twice two objects with the same identity" do
    @type.id = 666
    @type_copy = @type.clone
    @type_copy.id = 666

    clones = ActiveRecord::Base.deep_clones([@category, @type_copy])
    category_should_reference_type(clones)
  end

  def category_should_reference_type(clones)
    clones.should have(2).entries

    type_clone = clones.find { |clone| clone.parent.nil? }
    category_clone = clones.find { |clone| !clone.parent.nil? }

    category_clone.parent.should equal type_clone
  end

  describe "identity token" do

    before(:each) do
      @saved_type = ItemCategory.new(:name => @type.name)
      @saved_type.id = 666
    end

    it "should make sure an unsaved record's identity does not change" do
      @type.identity_token.should == @type.identity_token
      @category.identity_token.should == @category.identity_token
    end

    it "should make sure an saved record's identity does not change" do
      @saved_type.identity_token.should == @saved_type.identity_token
    end

    it "should make sure two different and unsaved record's identity are different" do
      @type.identity_token.should_not == @another_type.identity_token
    end

    it "should make sure two different saved record's identity are different" do
      @another_type.id = 667
      @saved_type.identity_token.should_not == @another_type.identity_token
    end

    it "should make sure two different typed saved record's identity are different" do
      item = Item.new(:name => "Petits pois")
      item.id = 666
      @saved_type.identity_token.should_not == item.identity_token
    end

    it "should make sure two record's with same id have the same identity" do
      @another_type.id = 666
      @saved_type.identity_token.should == @another_type.identity_token
    end

    it "should make sure a saved and an unsaved record can not have the same identity" do
      @saved_type.identity_token.should_not == @another_type.identity_token
    end

  end

end
