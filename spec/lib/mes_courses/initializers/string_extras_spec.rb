# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012, 2013 by Philippe Bourgau

describe "String extras" do

  it "starting_with? should work with string prefix" do
    expect("Nice weather today").to be_starting_with("Nice")
    expect("Bad weather today").not_to be_starting_with("Nice")
    expect("Whatever").to be_starting_with("")
    expect("Sunny weather today").not_to be_starting_with("Sunny t")
  end

  it "starting_with? should work with regexp prefix" do
    expect("Nice weather today").to be_starting_with(/Nice/)
    expect("Bad weather today").not_to be_starting_with(/[NM]/)
    expect("Whatever").to be_starting_with(//)
    expect("Sunny weather today").not_to be_starting_with("Sunny [a-c]")
  end

end

