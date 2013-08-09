# -*- encoding: utf-8 -*-
# Copyright (C) 2013 by Philippe Bourgau

require "mes_courses/initializers/enumerator_lazy"

describe Enumerator::Lazy, '#flatten' do

  it "returns the same collection as stock flatten" do
    tree = [[1], [1,2], [1,[2,3]]]
    expect(tree.lazy.flatten.to_a).to eq tree.flatten
    expect(tree.lazy.flatten(1).to_a).to eq tree.flatten(1)
    expect(tree.lazy.flatten(0).to_a).to eq tree.flatten(0)
  end

  it "processes items on demand" do
    processed_items = 0
    enums = (1..3).lazy.map {|i| (1..i).lazy.map {|j| processed_items += 1; j}}

    expect(enums.flatten.first(3)).to eq [1, 1,2]
    expect(processed_items).to eq 3
  end

  it "returns empty list for empty list" do
    expect([].lazy.flatten.to_a).to eq []
  end
end
