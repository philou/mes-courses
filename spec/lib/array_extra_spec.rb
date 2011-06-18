# Copyright (C) 2011 by Philippe Bourgau

require 'lib/array_extras'

describe "Array extras" do

  it "starting_with should work" do
    [:a,:b,:c].should be_starting_with([])
    [:a,:b,:c].should be_starting_with([:a])
    [:a,:b,:c].should be_starting_with([:a, :b])
    [:a,:b,:c].should be_starting_with([:a, :b, :c])

    [:a,:b,:c].should_not be_starting_with([:c])
    [:a,:b,:c].should_not be_starting_with([:a, :c])
    [:a,:b,:c].should_not be_starting_with([:a, :b, :d])
  end

  it "ending_with should work" do
    [:a,:b,:c].should be_ending_with([])
    [:a,:b,:c].should be_ending_with([:c])
    [:a,:b,:c].should be_ending_with([:b, :c])
    [:a,:b,:c].should be_ending_with([:a, :b, :c])

    [:a,:b,:c].should_not be_ending_with([:a])
    [:a,:b,:c].should_not be_ending_with([:a, :c])
    [:a,:b,:c].should_not be_ending_with([:z, :b, :c])
  end

end
