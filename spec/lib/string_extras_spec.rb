# Copyright (C) 2011 by Philippe Bourgau

require 'lib/string_extras'

describe "String extras" do

  it "starts_with? should work" do
    "Nice weather today".starts_with?("Nice").should == true
    "Bad weather today".starts_with?("Nice").should == false
    "Whatever".starts_with?("").should == true
    "Sunny weather today".starts_with?("Sunny t").should == false
  end

end
