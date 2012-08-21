# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

describe "String extras" do

  it "starting_with? should work with string prefix" do
    "Nice weather today".should be_starting_with("Nice")
    "Bad weather today".should_not be_starting_with("Nice")
    "Whatever".should be_starting_with("")
    "Sunny weather today".should_not be_starting_with("Sunny t")
  end

  it "starting_with? should work with regexp prefix" do
    "Nice weather today".should be_starting_with(/Nice/)
    "Bad weather today".should_not be_starting_with(/[NM]/)
    "Whatever".should be_starting_with(//)
    "Sunny weather today".should_not be_starting_with("Sunny [a-c]")
  end

end
