# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

describe "Array extras" do

  it "starting_with should work" do
    [:a,:b,:c].should be_starting_with([])
    [:a,:b,:c].should be_starting_with([:a])
    [:a,:b,:c].should be_starting_with([:a, :b])
    [:a,:b,:c].should be_starting_with([:a, :b, :c])

    [:a,:b,:c].should_not be_starting_with([:c])
    [:a,:b,:c].should_not be_starting_with([:a, :c])
    [:a,:b,:c].should_not be_starting_with([:a, :b, :d])
    [:a,:b,:c].should_not be_starting_with([:a, :b, :c, :d])
  end

  it "ending_with should work" do
    [:a,:b,:c].should be_ending_with([])
    [:a,:b,:c].should be_ending_with([:c])
    [:a,:b,:c].should be_ending_with([:b, :c])
    [:a,:b,:c].should be_ending_with([:a, :b, :c])

    [:a,:b,:c].should_not be_ending_with([:a])
    [:a,:b,:c].should_not be_ending_with([:a, :c])
    [:a,:b,:c].should_not be_ending_with([:z, :b, :c])

    [:a,:b,:c].should_not be_ending_with([:z, :a, :b, :c])
  end

  it "containing should work" do
    [:a,:b,:c].should be_containing([])
    [:a,:b,:c].should be_containing([:a])
    [:a,:b,:c].should be_containing([:a, :b])
    [:a,:b,:c].should be_containing([:a, :b, :c])
    [:a,:b,:c].should be_containing([:b, :c])
    [:a,:b,:c].should be_containing([:c])

    [:a,:b,:c].should_not be_containing([:d])
    [:a,:b,:c].should_not be_containing([:a, :c])
    [:a,:b,:c].should_not be_containing([:c, :c, :c])

    [:a,:b,:c].should_not be_containing([:c, :b, :c, :d])
  end

end
