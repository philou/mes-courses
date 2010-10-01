# Copyright (C) 2010 by Philippe Bourgau

require 'spec_helper'
require 'all_matcher'
require 'lib/deep_clone'
require 'app/models/item_type'
require 'app/models/item_sub_type'

describe "ActiveRecord deep clone" do

  before(:each) do
    @type = ItemType.new(:name => "Viandes")
    @another_type = ItemType.new(:name => "Riz, Pates")
    @sub_type = ItemSubType.new(:name => "Boeuf", :item_type => @type)
  end

  it "should clone a simple record" do
    type_clone = @type.deep_clone

    type_clone.should be_an(ItemType)
    type_clone.name.should == 'Viandes'
  end

  it "should not hashify the record ids" do
    @type.id = 666
    type_clone = @type.deep_clone
    type_clone.id.should be_nil
  end

  it "should dehashify nil references" do
    ActiveRecord::Base.deep_clones([nil]).should be_empty
    lambda {
      ItemSubType.new(:name => "Unclassified").deep_clone
    }.should_not raise_error
  end

  it "should deep clone a list of records" do
    clones = ActiveRecord::Base.deep_clones([@type,@another_type])

    clones.should all be_an(ItemType)
    clones.map { |clone| clone.name }.sort.should == ['Riz, Pates', 'Viandes'].sort
  end

  it "should deep clone a record with references" do
    clones = ActiveRecord::Base.deep_clones([@sub_type])

    sub_type_clone = clones.find { |clone| clone.class == ItemSubType }
    sub_type_clone.should_not be_nil
    sub_type_clone.name.should == "Boeuf"
    sub_type_clone.item_type.should_not be_nil
    sub_type_clone.item_type.name.should == "Viandes"
  end

  it "should add deep cloned references to the clones" do
    clones = ActiveRecord::Base.deep_clones([@sub_type])

    type_clone = clones.find { |clone| clone.class == ItemType }
    type_clone.should_not be_nil
    type_clone.name.should == "Viandes"
  end

  it "should keep object identity when hashifying objects with references" do
    clones = ActiveRecord::Base.deep_clones([@sub_type])

    type_clone = clones.find { |clone| clone.class == ItemType }
    sub_type_clone = clones.find { |clone| clone.class == ItemSubType }

    sub_type_clone.item_type.should equal type_clone
  end

  it "should not hashify twice two objects with the same identity" do
    @type.id = 666
    @type_copy = @type.clone
    @type_copy.id = 666
    ActiveRecord::Base.deep_clones([@sub_type, @type_copy]).should have(2).entries
  end

  describe "identity token" do

    before(:each) do
      @saved_type = ItemType.new(:name => @type.name)
      @saved_type.id = 666
    end

    it "should make sure an unsaved record's identity does not change" do
      @type.identity_token.should == @type.identity_token
      @sub_type.identity_token.should == @sub_type.identity_token
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
      @sub_type.id = 666
      @saved_type.identity_token.should_not == @sub_type.identity_token
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
