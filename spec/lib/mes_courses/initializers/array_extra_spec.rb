# -*- encoding: utf-8 -*-
# Copyright (C) 2011, 2012 by Philippe Bourgau

describe "Array extras" do

  it "starting_with should work" do
    expect([:a,:b,:c]).to be_starting_with([])
    expect([:a,:b,:c]).to be_starting_with([:a])
    expect([:a,:b,:c]).to be_starting_with([:a, :b])
    expect([:a,:b,:c]).to be_starting_with([:a, :b, :c])

    expect([:a,:b,:c]).not_to be_starting_with([:c])
    expect([:a,:b,:c]).not_to be_starting_with([:a, :c])
    expect([:a,:b,:c]).not_to be_starting_with([:a, :b, :d])
    expect([:a,:b,:c]).not_to be_starting_with([:a, :b, :c, :d])
  end

  it "ending_with should work" do
    expect([:a,:b,:c]).to be_ending_with([])
    expect([:a,:b,:c]).to be_ending_with([:c])
    expect([:a,:b,:c]).to be_ending_with([:b, :c])
    expect([:a,:b,:c]).to be_ending_with([:a, :b, :c])

    expect([:a,:b,:c]).not_to be_ending_with([:a])
    expect([:a,:b,:c]).not_to be_ending_with([:a, :c])
    expect([:a,:b,:c]).not_to be_ending_with([:z, :b, :c])

    expect([:a,:b,:c]).not_to be_ending_with([:z, :a, :b, :c])
  end

  it "containing should work" do
    expect([:a,:b,:c]).to be_containing([])
    expect([:a,:b,:c]).to be_containing([:a])
    expect([:a,:b,:c]).to be_containing([:a, :b])
    expect([:a,:b,:c]).to be_containing([:a, :b, :c])
    expect([:a,:b,:c]).to be_containing([:b, :c])
    expect([:a,:b,:c]).to be_containing([:c])

    expect([:a,:b,:c]).not_to be_containing([:d])
    expect([:a,:b,:c]).not_to be_containing([:a, :c])
    expect([:a,:b,:c]).not_to be_containing([:c, :c, :c])

    expect([:a,:b,:c]).not_to be_containing([:c, :b, :c, :d])
  end

end
