# Copyright (C) 2011 by Philippe Bourgau

require 'lib/string_extras'

describe "String extras" do

  it "starts_with? should work" do
    "Nice weather today".should be_starting_with("Nice")
    "Bad weather today".should_not be_starting_with("Nice")
    "Whatever".should be_starting_with("")
    "Sunny weather today".should_not be_starting_with("Sunny t")
  end

end

