# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

require 'spec_helper'
require 'tokenizer'

describe Tokenizer do

  it "should return an array with the given words" do
    tokens = Tokenizer.run("petit poi (extra fin)\r\n\t--- produit france, provence. poid net : 14g; trace xxx ? !")
    tokens.should == %w(petit poi extra fin produit france provence poid net 14g trace xxx)
  end

  it "should remove irrelevant linking words" do
    tokens = Tokenizer.run("riz au saumon, produit en france, plat à cuire")
    tokens.should == %w(riz saumon produit france plat cuire)
  end

  it "should singularize words" do
    Tokenizer.run("tomates").should == ['tomate']
  end

  it "should downcase words" do
    Tokenizer.run("Confiture").should == ["confiture"]
  end

  it "should remove accents" do
    Tokenizer.run("pâte").should == ["pate"]
  end

  it "should remove duplicates" do
    Tokenizer.run("creme creme").should == ["creme"]
  end
end
